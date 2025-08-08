Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C37FC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 16:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3466B0099; Fri,  8 Aug 2025 12:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A43B6B009A; Fri,  8 Aug 2025 12:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5136B009B; Fri,  8 Aug 2025 12:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D99616B0099
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:41:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F905C022C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:41:43 +0000 (UTC)
X-FDA: 83754156486.06.E44C95E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F5391C000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:41:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FhW6W7li;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754671301; a=rsa-sha256;
	cv=none;
	b=b0bbCfNN/mCKXP50LZZ0wUwTrIUSl2PtBL70obF8rh9P318hFBX2XRXQmqE4oYMG2O45rU
	Jf37c4WchZVbCGuitUCmBhsaxzYv+c/z1aEQ3hK2xWhyyv5CadxJ3cEm4nrhRZMOXBmDqj
	L7ae07bdaEGdTSZjlumMvm3+6hEjLlI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FhW6W7li;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754671301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfdUfMqWlDOmJex++lFk1qO6nnIBP0OFGSpkvrWBx0w=;
	b=Ksx4uiT/uPJW2dAcG12Fd9vGELh4GUzSiftj/Q5Emkmj2/SyGaPgsC0PhvcWozFvJ0BNG6
	A5UfBIyRXQKMTYsJIm/mY+kxjLePDD5og7H7xm2RWgGIlfNWsE5p/3rufeTa0+W+wgtwXV
	B6XcJ/JEyHhsZw/gd+X21mKBW9Uh19Q=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6156c3301ccso16a12.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 09:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754671300; x=1755276100; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfdUfMqWlDOmJex++lFk1qO6nnIBP0OFGSpkvrWBx0w=;
        b=FhW6W7li741HGm4YHr52JWGv/aNxBWBE+mOid3Y/kmQzzK+j0+Vd960L5mFx6DvlfO
         vEmXs3GA9VEp8l5DkbfSSxl/FSN2LJnOPovwkDekYJ683eESSsGWzTLzqNQkIO8u+kEb
         mXhaUiLUujtJW5650VfTsLWBqfAjdVYUwq69iSLOcDUeswRp27MM+azIyNxeWL9wRQbW
         GWqkRJg9mTOI7Rsd7GMM0uvz8ZInvpDsvuIvo8Rx2A8PTQgNfLdlwxMiLQEcOGbEXLVZ
         Quly1zwlKwiSWvoCsHdYql/m39Q1ij1XDqtbg2VpMHKQawTwT+6HklXLC/ThvhEvDX/n
         7KCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754671300; x=1755276100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dfdUfMqWlDOmJex++lFk1qO6nnIBP0OFGSpkvrWBx0w=;
        b=iVWY9tLgbM/AFPhW9TckeYP/GTACdH9XYfs+lzzdpmW6ftgvKjjAwnhdMTDTT4jwUf
         dDjdjvsS/XG/jgLEsbIPLsYStycAFKIKymzj8nakK2ZPIxdEGJ/lTAujodW7VSgPKUZk
         vz7Key3T5RgmHEqdtfeAVZzdgU/bp+V61OKVTPCVuBoxmr/5yYv7tj/+JKIlbM+l0xNN
         NIpo3DEjsrhYonyUMJBeyvri9BHDHDojAfrnTCTdc2/8CA2UeICI0NTExucB/+/apap1
         4Yvxx1PTrcrTYRKAwxvn7fa8K9iGYoHVtqGJnQGJGx5lt67dVDjIJFCArKyTlxRb4jQd
         vWAg==
X-Forwarded-Encrypted: i=1; AJvYcCVU2X/M332gC1p8Bohnco68a+lmRsgk368EIej6RIIZkEPNDGGt7PBb1+U0uxKs9XHTW75HsyazQg==@kvack.org
X-Gm-Message-State: AOJu0YzqHfSaVZ7pDh0Qz2qB/Wn/czBLB4lcraCRWx9CSJylAcGv9gCl
	VQCa6pIef7IypUoyW8ofUFuQ7DX3ZOFBgeww1GghxMCpCelidBEYagJ0JVryWhnA2+G2Q4x8IGL
	XsTHJol3NL0nnfI00B+OJ+1gQqbqxOsGcQRB6HIqR
X-Gm-Gg: ASbGncv01z8SW8/5XIUH2i134N7zA2GFUwwr6mlnJl2pfI6Sgk8r/VdOr54U9BRld0E
	1znpZmF5kgVPWBq2413n8x3oNOS2HuWj8+v02pMso+2+PMi5BO5lFPVu1YidQa84mBZIA9PccAz
	FkEVBtSOl6jxfy374853ZPo8LBCqO0KSg9Ib1zYTSqXxgscE8e3s8sKLQPF61T7ASkghzkW5xCT
	VbCkpxYuMnlHgpyS2En4yY5MRDd4Lfy7nmo9ADgsA==
X-Google-Smtp-Source: AGHT+IGcT1Fa1wAmQd/OSoCSWiqxxrHCCt8PYFL+Ygdztx19r9wleJKk1M6kSna+PxJBsaxfyKbUlyZTlO/6NquFBsE=
X-Received: by 2002:a50:d516:0:b0:617:9274:5bb0 with SMTP id
 4fb4d7f45d1cf-617e48fefe6mr91904a12.3.1754671299708; Fri, 08 Aug 2025
 09:41:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250807103902.2242717-1-lokeshgidra@google.com>
 <aJT7qQzEs_p36yfI@x1.local> <20250807155401.683c77b0d0cb5c9ec88089e6@linux-foundation.org>
In-Reply-To: <20250807155401.683c77b0d0cb5c9ec88089e6@linux-foundation.org>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 8 Aug 2025 09:41:26 -0700
X-Gm-Features: Ac12FXyfe3klaRIC0BNFV6P8qrkr_FZHrNFM2dPy8TEb4JRfxMOXo149i-LIVQQ
Message-ID: <CA+EESO4zWAo=AwohgsGdHNmuLOiuPs1C-FOg4FHrtqiUTdY84g@mail.gmail.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8F5391C000C
X-Stat-Signature: 5pc893szw4kz7rsgrio9kum5pfpbadnc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754671301-670265
X-HE-Meta: U2FsdGVkX1+Y7QQ7FEeJhMYqTlPjqcjjEKalP/fWKU0TUbXPApwzwlpTFSRb+y4p9p/f+6NL1Jvq86Fm8+1f9fLBwf5AHWRS4czXqNaSMSChWqtxrfjXmf0ZNhCy3oex4kh1C8FQZODDFpkdvvU8E4GfqVV5MvrvoUV+/NLcedxdjdH0muynQQo1EIxDbnOyHccR4YMkOFYoxIYDK88KIqZhsJHuYpmVKz2arJE+myydpXpwrArBLOPy1Lcq7cW060wLkSWLF1b1SuUiezYbbR0eJg/MjiX2twNO1PqNVIzbnuegSKQetC6oxoE+Z/pFf+TXkOiBAiPgvLcihz4Zz1vozY2ufd2m3jVP4FlIINhylNMn610V70YfZ5Xvgwm9jCFAUiL5tXZSvThYN1C1XcRBMPmAYoa2pzrM/UcpOIYFk5zRkmydchTNIlZQs2MOujtYBZw+yUvv8WDhXiuVHLJOmvqUCbpihWz7l5qW7mGYApPi5fWLcb2RiLUTpdrECkxTLZ0e4sqeuUusB1fyoMKARyLwU+GzxQC99KNsvAqYtOQJw4uylhZ0gnEMuG5WPxD7FqLsIx5hoj37bl/RV630o1IPuXTXDB3hRldHZQGth5xjlffivB31tO313x+Z3Lcf6voYqGx/cES3hDz9lvS/FAvj/emFeWRbZAzBG18oC6GVn/OnZIkVbFOxIky2TV1tn4YcQRMDAe90+yUkO1EdorefOqwBaafHvGtYVdMrMhzI6YLrpFhUjm6+VfJXybl3Lhh6ywA6YbTUD7A2Vc004vtfUDcHl6AVZvGGFcL0W23Fba69QjUeoch1AjpHxs4NGWjGc2Wn2JTqPlXbcEzUkQQ7IN17ORDlwa0zxBUe6dRwm0Eg46SzepdiM6dabs+9T619cUieHmrQ9RvmiET5sjEbrYC6hQSp9xtxh3/q/CiaZJVaMbjE4cV+z+XGircJr5lGStpPm1YB8qi
 X4CV6HKo
 NBsigF5IJV2ZBPh9cgqDn/U/3PGtLsuF52vgtmq+eYYxmLxXC1M1Ph2tO1Aat6mSKDQlWtzYNv5wEtaQB952lkk6FjTM9OZ1PcPQxYeHq38fsIwhZ1t6I5Ea/A06aA286T1OtAyQmKkiLBZIEnKxCKIvmCEJDid07nImHvNE2abH6oV2IxzhpojPBHzhMYCh597f9koh2ZUy7xlt/DstziCujkM2nakSPjSY6xYN+oko+sSgP72YLCxvj3anzlvlBYr2tvwOqBNtNTKbSilyF+Omeb5TKXUmbHoFf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 3:54=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Thu, 7 Aug 2025 15:16:57 -0400 Peter Xu <peterx@redhat.com> wrote:
>
> > Hi, Lokesh,
> >
> > On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is require=
d
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD=
 GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the tot=
al
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), an=
d
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> >
> > Do you know why vm_normal_folio() could be expensive? I still see quite
> > some other things this path needs to do.
>
> Maybe as explained here?
> https://lkml.kernel.org/r/20250807185819.199865-1-lorenzo.stoakes@oracle.=
com
>
Thanks for sharing this, Andrew. IMHO, this seems like the most likely
reason to me. There is nothing there other than a cold access to the
page struct.

>

