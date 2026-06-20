Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C704CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 05:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EA606B0005; Sat, 20 Jun 2026 01:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B6C6B008A; Sat, 20 Jun 2026 01:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063D46B008C; Sat, 20 Jun 2026 01:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D53FF6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 01:02:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D5291C5227
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 05:02:57 +0000 (UTC)
X-FDA: 84899096394.19.F641EAD
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 33957160003
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 05:02:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O2qWmUiR;
	spf=pass (imf08.hostedemail.com: domain of stevensd@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781931775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0iI9bSF47iakb7tyW0taNGyAqiHP/K8psT2l20DPKs=;
	b=e9BFrSwnvFWckc58oQ4A63Z9L3UsLxBKEtyeUUsXQ3S2K+0tu38H6kFq4nfMnhmYA/yD+/
	dTvaRaZKG3x0nFz2fONDVwjNGwtLtG5kAtBTmVpxZ5BpscuqGb9XbzJIMhY+scLHGBlNMj
	oXItzewfUpeEwilLhYVwyTGmfwLpQ5o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781931775;
	b=3G2B8Puf6q3zTJJTo2TjQw0t2KJm8qJr3savpexEWbxv/kQnYe19+DC1HcAlvqpGXr1HXP
	th1QmIaXJKqaflE0KhIhdIfDm4JYZoxbVhnBPPDT4CfX6TV2WYIbxnbUyNLkpJa4ZohQTr
	aTSe0/cmfBjK4UQWvVg31T09+h49GeM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O2qWmUiR;
	spf=pass (imf08.hostedemail.com: domain of stevensd@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69605f796b8so11848a12.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781931773; cv=none;
        d=google.com; s=arc-20260327;
        b=IJSWNjKCqcgMkEpnuIN7YEyK79MnTbRmK4kNzx9Qv9Bi1Ay4VPaICFfY9Oft8i9fRp
         AhB4OxbrzhQ3KlXcatsv6ModKhySTwFRnhpY9UKcg5NlD+8PFCX0DwcqUGPzjm9ehXn9
         QnUD8F3gVfC00cVUDa7szvJgYfclMuik8PmdVf47sTqM9E1V+by8IyDz84ZDFF6goFFv
         xbFCAiHaIZHCqHOFmh098t+SNjjws9su6hPLap1W7UGucNjia+CmS6d2RlglcqQgSTFM
         uL1sQr6blSe1h5ljLcevhU9nbUy0tuOgbMEYB2WwHdCBJHyIhjh/gwj2BjuBR9ws6R6r
         vTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q0iI9bSF47iakb7tyW0taNGyAqiHP/K8psT2l20DPKs=;
        fh=la4TTex1r112Cyf91+nl/p3OBPaMWnZJKtTZtfgYBMU=;
        b=H6QEl+r9FRjbi6T4D3hiiInNcmavn2Tn5ZhUeCNSLHKacP0nQWwqJhTnsA+O5d5V4r
         50qchvHAYny23lu4qsJbPmeVEtGVumLS701EjUzpUnmoiMRB9pFzLXkKwtXWm7Y29ywG
         YsCXMkcde7jc++Pq1eGE7TGQYDYAxC7R2z+pNvK2LA+aRIxNCBRWtSiBeQdxsLcbtT5X
         kOQjeHjN6dReTUlwjp/bseplyu3bb57i9EKEMd8jOI7+2o7oLdUeuyJM3p7ofYIp6L3N
         9iG7ufaqThmk8fi3yiuGJ5i1X427SA5/3HvixjHk2PXGAqswtk2dCYzwge5zKAfvskcx
         0lpg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781931773; x=1782536573; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q0iI9bSF47iakb7tyW0taNGyAqiHP/K8psT2l20DPKs=;
        b=O2qWmUiRx/PgCJHiTYqmpV9kR8eBdV8UNNyCj/lNxwUoSmj+MRBr+5XiwyAQlFjTkN
         0LtRPbtSJ2Xf29KqGwT+DPyLg33AqOssURF8F/1GBvp4UlCPyG+B47xBQMt9wdUzBHcP
         OEthCGrsPvZUeXR7AZuJwWVeuM0yDer0gOwk++BjX6BS/XGXk8p8CEDwI6PfPH+H0/gy
         NiCpjqpG0myk3wTiFArQCfsf/xF0vFkVTBMvzDTabBjZTMVppOh25+3gfdJPiWTjnOOo
         03Z2EjGVulG/Db8g4oqjdvozjBfb3+9+80FLMVQRhjBnFYCvp5r5dGEsfYdBBE0g6Ay1
         V/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781931773; x=1782536573;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q0iI9bSF47iakb7tyW0taNGyAqiHP/K8psT2l20DPKs=;
        b=mhtV+l8AgCFIDO7O9ttQ+WtC67NTwGSuB+KrPXde5+ftN5/pmziQIYIAXq81HoBOEG
         Rwe27tiVusAu2GOnMtz6otRgm0tXH3zM+KJs/Lc4YfyS/M82e3RpbiIIRPqduLuPwtQL
         C+qkaEbwE8O7xXFpvxyMEj33prQqjx1BbOZp3C6FundgdAHY1eS5d2RJ94yLjyAU2JEg
         +mw7dWt2fsQf5EoTz2h2WHwsg1xXux5KvCg19Pm8mE9U12eRDq2siS8vV/6XX/xaFWnH
         l5sXc4/FAVg2dCoo0zCqqm3DE2Wv8fOFSM+rOmyguh7cuR9ld5PZ5fMgzAurprvVPZge
         DZJw==
X-Forwarded-Encrypted: i=1; AFNElJ9QIqMsTSCF32pNofp+PcqCFYa0kUkGIlpG5l+T24Cwy3+cnfy7PCjnGb788PRr8mYqvakHqFTlNA==@kvack.org
X-Gm-Message-State: AOJu0YznmryP60cqnVZI4Nu7uvEWt7dH3gIAC+tQeOX3jT/wJ0fhHUSA
	vvTeDeg4YvtOx7PxNRZCVF0F0ItX7L4Rfjm5AszHoiSQLAtKKI+o8TBiHcZs4bSnPnqz3zg/nrT
	Yh271pfwnrM19AAsPC7Bkh2nFZ2DYk3/mWHKPdA0v
X-Gm-Gg: AfdE7ckemd2k33Y73YbhdM6V5uhNbVCe3DZ8M+u9qkBip7sfU7e2JWDxg6t8u0OxEBd
	W16m98pKkl9t43w8V+6cOyVGU2k8You1q9udSjrttSTmuGKTvfIzoSJ0+Jo12x8S2NnT1a/6VAr
	aTvBoi6sU1FEnEkJj2QkE+mSlM27/kDN1IPRUfoV9Gfebs0E5vlWBS02F312o2hZymEUzOyxKyA
	rCNde8NXafvzGmpv8CeWQKxHlFMpXS0RzNm4LYodl0z6Lz63WcHSJEaAKSk4+9/Nd9AgBiHXTFb
	qZcyeHG4TUm+LtpUIYuiR5iSF+w=
X-Received: by 2002:aa7:d644:0:b0:697:6207:bad9 with SMTP id
 4fb4d7f45d1cf-6976207cf04mr28895a12.2.1781931773020; Fri, 19 Jun 2026
 22:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com> <87qzm2b39k.ffs@fw13>
In-Reply-To: <87qzm2b39k.ffs@fw13>
From: David Stevens <stevensd@google.com>
Date: Fri, 19 Jun 2026 22:02:39 -0700
X-Gm-Features: AVVi8CdYsUgsv573HUpfVVTdLRp23QhLPSRh7IggFdi1Dy7-4X398t61LvilB1Q
Message-ID: <CAOiLmNFC+BWdBNm_waA2Ly1x6oyCzsomc0AM=r5TkQK3YskfGA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Thomas Gleixner <tglx@kernel.org>
Cc: "Zach O'Keefe" <zokeefe@google.com>, Dave Hansen <dave.hansen@intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33957160003
X-Rspam-User: 
X-Stat-Signature: q83w8nhq4ptt3h8bg65xoukxt41x7pxu
X-HE-Tag: 1781931774-789879
X-HE-Meta: U2FsdGVkX1/o5diYYykuoqd+EROUB2x0hrAhslk5+20H0z5PBqVjg/oM4qFOv76v+SD6YYBR0I56TVFCpyVmhnHB3M9oa9Mds3J11OUJkmdEok2L6RX8IZDAS/PtxWzEAc3uiwZm2Dc78Wf9qzcq6qqZEdYZL/IVirOWdGlWDtovNLP6HHAaOYdV07AR3elthpHRtLk6RL2ROiLrxZhREsdjPac1zd75bY8u0BL2ncY48TMTBdh+CxhR2B2DFvsuVxcmlaqLHz7jxZtJrs5UVRVqp4OIxzukoqy0vNP+PhFTBtkm89k6G8B7ptAS4ogYI0h45fLqL028CX7kG3jYQyRFj2TY0rpXoL1Ig9WjMTIi29SZsQ2zgw8ui4o3opcfPePDuS16mHKYNz6L1X7e2fTKw9VmPr+pFZ7IXNwHO+Ej9aNyU5UeCOjb7e8/yV27Tc/5j9k+tVWw/voltF2WOmA38EadCRp+SqFWMNcH1KQSc9c9SpNnEC+vYZp+aGkR9wupIYXxxVLXk0/1FpkF0KcVM6xw7zy7W0++EV7jCERJ5Ubw5GQ6EK0iomGWJARq4gbCSL0paiacBLlV4Y+VArtcYKk1/XD6bLCHmKsQ9B1273Bo0yHcGFxfJ7XekJ6z/wkUyB9lXQ6k6Mv3wRbd0vwBZynLUcxFA9D4QyMstXCBLRjKS8GeqwdOoh9sLOFwpWj2MtOtaEEGhjh63ZsiI1/8pJ9oXu3gaCPW90cCB8C+G68mvPrCqpHSDYuAObzJH63S/x9bwPquuVuTKXV64uQ67xKmozqGXeKQ9esEF7qUOIl4AIUHcedom7gT4nUunSsQkGFOwMgiPy/9QkWPYfMKiLfEmxhr1pFsX4MjQAB9ePPymTBuEeltZCdjuOUkqjES2N4agzDSShrgY+8ZfBYKWHU2tiUtV6l+068yvoNvVG3igwdmEzcEI8TrDUVBYGP216MH+QHcUMGBrNP
 S0FSBvqN
 lk8ObsGRYFtiOBd29shxVKIExc8zylEvlUB3hzl1Hhg2RVchRb9LhdBnVfzHNSA6fIsHNdhti+2T4lq3cydxoY+XiwyY8nintULw5us7UC/YxCsZWytalMGJlsCNXUO23xVGBr04/9O7pyFvWkCv2kWYZXFAP0XbbeOznHxACQ/qWjpzVQ+GpnF8BdJzCt0cf0k745EDD12O5sBpsYNJBuAntpaRipficPf/YwaCdojIz6k+j9IH+8yoz9xI59VWKXQWX+RrXJfTDO3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> Zach!
>
> On Fri, Jun 19 2026 at 12:20, Zach O'Keefe wrote:
> > While it seems common opinion that the IST-based solution is fragile,
> > what of FRED? It seems like this is exactly the kind of support needed
> > to avoid some of the aforementioned sw "mess" in various x86 exception
> > handling paths. I agree that it's less-than-ideal that we are forced
> > to downgrade exception levels in the common #PF case, but is that an
> > unsurmountable problem? Pardon my ignorance.
>
> The #PF path is considered perfomance critical. But how much the
> downgrade matters needs actual numbers to analyze under various workload
> scenarios.
>
> I've not seen numbers to that effect anywhere. The only numbers provided
> are marketing material about the memory savings on a freshly booted idle
> machine. There are _zero_ numbers about the actual real world savings,
> but claims about the PETABYTE savings possible.
>
> Seriously?
>
> > Lastly, I just want to clarify what folks have meant by "extraordinary
> > claims" or "evidence".  Aside from the above discussion on FRED
> > exception handling, the "only" other part of this is the allocation.
>
> Clearly anything which is explained with "shouldn't happen" and
> "unlikely". At cloud scale nothing is unlikely anymore. That's simply the
> reality of statistical math.
>
> As I pointed out before the same applies to the unexplained
> upgrade/downgrade game with external interrupts. Such issues cannot be
> papered over without understanding the root cause as from decades long
> experience they come inevitably back some time down the road. Cloud
> scale even guarantees that.
>
> > Are people concerned about memory unavailability, deadlocking-type
> > issues, or something else? We have considerable design freedom here to
> > avoid certain classes of unreliability, but=E2=80=94barring any clever
> > tricks=E2=80=94I don't know if the allocation can be guaranteed to succ=
eed in
> > all conceivable circumstances. I want to ensure that reality does not
> > present a hard blocker.
>
> First of all the failure scenario has to be clearly defined.
>
> Right now, if I'm reading the patches correctly this simply can end up
> killing the wrong tasks/processes just because an OOM situation results
> in a depletion of the per CPU cache and the very wrong task which runs
> into the deep call stack situation ends up in the creek without a paddle.
>
> Given that you even fail to abort a CPU bringup when the allocation of
> the per CPU stack page cache fails, makes it pretty clear that there has
> been spent exactly zero thoughts about this problem.
>
> Why the heck does this cache refill call have to be unconditionally in
> __schedule() where preemption is disabled and therefore GFP_ATOMIC
> is mandatory? I know "Works for me" (most of the time).
> And just because I was looking at the patch in question I found this
> other insanity:
>
> > +     /*
> > +      * Most likely we faulted in the page right next to the last mapp=
ed
> > +      * page in the stack, however, it is possible (but very unlikely)=
 that
> > +      * the faulted page is actually skips some pages in the stack. Ma=
ke sure
> > +      * we do not create  more than one holes in the stack, and map ev=
ery
> > +      * page between the current fault  address and the last page that=
 is
> > +      * mapped in the stack.
> > +      */
>
> Can anyone with a sane mind and the most minimal understanding of the
> kernel's inner working explain to me how the kernel can skip "some
> pages" on the stack?
>
> If the kernel skips a whole page or more then there is a serious bug
> somewhere. I might be missing something, but again the "very unlikely"
> wording which handwaves about it is just disgustingly useless.

FRAME_WARN accepts values up to 8192 bytes, and it can always be
ignored or simply disabled. If a stack frame is larger than 4k, then
it's entirely possible for the code and compiler to align in a way
where the first access in the frame skips a page in the stack. I think
we agree that such code would be highly suspect and (hopefully) would
only exist in out-of-tree drivers. But it's something the kernel build
system accepts today. Dynamic kernel stacks suddenly turning that into
a runtime kernel panic seems like exactly the sort of edge case that
we would get yelled at for not addressing.


-David


> I disagree with Dave on the RFC status of this series. It's not even
> close to RFC, it's at PoC status.
>
> Thanks,
>
>         tglx

