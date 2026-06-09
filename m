Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30629CD8CA7
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:11:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9C36B0005; Tue,  9 Jun 2026 04:11:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9FA6B0088; Tue,  9 Jun 2026 04:11:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398D56B008A; Tue,  9 Jun 2026 04:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 297E56B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:11:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C39BC1204BA
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:11:45 +0000 (UTC)
X-FDA: 84859655370.01.E8E7859
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id BB1C1C0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:11:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YacnIGR1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QsY1n5N4iqtdC4BlDMhKaWRGC0gk3S4nMtz5szdAAI=;
	b=wunqaVikTlyKBsHd3pNQ1UuY4iyQn+WXFA1mt+KzeLTaF9LW3VH3lYDFEE7Uz/Z5mSYSLY
	QNAgv7LsUKwcvbjUm7j0dlILgJ5YrTarhkzog3T1WnlKTehp9l2Y+5gmqIzzj1eQJkfrME
	MOnQtkz590yqAwSVwM4VoYuKI+zoQPM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YacnIGR1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780992703;
	b=ISK99zGP5K1mux1y83/MlW5vK5htFMut1taRuy7qY3HwCZ1hBaTpd2pQvbYgUAszPxCEd8
	cQIC3xayO9xnjMpwwx21xDpU0BKyyLR2JwVgFj7UI+zPi0EXZO6D+qqM+Y2VvXdo2+SA/Y
	KxVvm/F+hLXh+PpSsNrTLyJvlFCXWgk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490d1e54b3bso15243785e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 01:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780992702; cv=none;
        d=google.com; s=arc-20240605;
        b=E9vNm+9rwY6Zn2ymjM3bxHO29n6K55cLd/9ZWY0tCIx6Rt2kKtbb5fBPQmPWD8FfBW
         vsPNnLE/eFbAwdCgNT1niP/O3dTS+tHtpVYmIPTfMebcchkFCpp4836mhC9awCFa7Dzo
         uZgbjT3C6cIFDXbclmXo8aaP/l1b82gD4qR7owpUFDVWNBVQir+bPDSTFdGTUNMOeN+D
         iPJYPA04Q7jvZplxmd4tXeUVLYvSwYOQf1aUjXnFh4/k2cO7JOvl/k1m24fR5g7McCQg
         m65gEnJ6xqFjaT7WEeCvnSU01xTmyO8Dp8C29m4IOMdbwqG+D0qSnaJfh5dNR909+5sH
         6LiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8QsY1n5N4iqtdC4BlDMhKaWRGC0gk3S4nMtz5szdAAI=;
        fh=RQCdDb6nyM0BOihcSzFeLjFJ2KMShNvK3ABOaU7XC/w=;
        b=eJij57UJNeZ4XNNjY1hCACCDRFAj4OPLAWpcMGObOalSXl3NQ34BfpJOTCjKJoc6PQ
         BrR5LamnBs1Zf2fHdClRyjFswrXsGC0nP793wdq4PX8opqYdHDBDnw+U//ucL2JMWHe7
         kHvU/Ivvtl5hqWQqJoVyE3GHzn2zHRY6nZXuPDtqjYTJ/yg8W4BELTBdWJfXTA4LwLC6
         hfMYQIG08a6nbM1ST7GnEkXD7fChiEFF+dDC/LtMMGedf5ObxUSqKxArqQweuZy351yU
         BdPs76YU7osaoS1DMJnyQCPN8OtBxQhsCXgLXtXex+vy+ZEFDrFH6o3pEP3Kt4/QxNVL
         X54Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780992702; x=1781597502; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QsY1n5N4iqtdC4BlDMhKaWRGC0gk3S4nMtz5szdAAI=;
        b=YacnIGR1+u5eoBCZx9lquzrTFXatGc45Eb3P1BGB/3a3Jl8W0W2VN414tdbmykdstH
         BQLTJSha+q+4ZzJKRgQaGEUyMiZ2yyHCp4JD7YJzENd6eaJIPNOL2iyeEmOfdyVxauT8
         ETNthGVLaBCV1mGF8PSWZqT7DMuiVwnUT79QTpZ21BdX+IYw5pUjd/GnJ1QchDmvxTTH
         HTAObfDRQHTuq330N6NNF2043qrLNg8nawK0cR5Omt5j0iiCzGPmeMpCiEUTQ73cHYEV
         /EjIiv/reEdrUV2o/AzjI/HSBWV15fvNrxyCzNQHbpV16CGS1TZK/Y7IQlrhkeza6m0Q
         lHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780992702; x=1781597502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8QsY1n5N4iqtdC4BlDMhKaWRGC0gk3S4nMtz5szdAAI=;
        b=FMmhobx694Foe9DfDTm5YGXHwZa5NXYbkW2z5ucEHtMAy3YZVk+0n7D6TJX0yS/o8P
         BXi/GOiWBHaf7IYzbb+nN4Zw8+xgIdmsjnpLpbghHodwCdS/X1hB+heps+jukhEfIUX8
         9kiQ42BKCKhNzYPlEVT3eBvY1asjdThIAwY25McMcs98drJ/s8aWi1bOrWx0Hxerdyld
         atC0F0FKPuQZ9osZY+Qjf25yheXWKLHrEAhgydgag0zrAeknTJ5vkcUG/KBaosBMwU/j
         4inZ8h4Plpw90WeIt7jfXguUiBSqNfi4RG1F+SxdU0Khsau/S457okpIUrijDNgP6hdE
         i1Nw==
X-Forwarded-Encrypted: i=1; AFNElJ+f6DNZsJo5WqHM4LxvfpzfPM4yFhSKyKmBadHqpmLNgR6hgvmy/QKEK+QFvHFHbMbRI0RC5vG9QA==@kvack.org
X-Gm-Message-State: AOJu0YyLbUmynwkM0jZb2WV1+l3zf0N14KJZ3bZ+9DRzX4tJuYilMigx
	++CJ+dmyGMaTVXEIVPSoFSasWgVzADQdYdcNa8bMjCRyGqMJioemfCaof6gqw0SpTaPfMExTAnV
	YD/ds/60ZNQL5HuZWNUJ/gHJhPU7Xyyw=
X-Gm-Gg: Acq92OGiap8LJktrhTJ0XcMV8xEwo8JBYMtga2vHEImGSNig3+Nbps2iPQQHpRPexRx
	8gg7ZSjLGhB/Y9IfSCACNVY9HAzShXwnPfzRkfep2yrNPijYxNUt1sV8QOL1HnPlYxipiZQGZfG
	6FYs+bcDVdmAG4Drgk+73LutiGm5TIagY8vgDGLNhP4rsxXZe21HA/iS1Qe51ssO/03ixHYd+5b
	6ydvTTiKuhy97fQA7LskzqnLRewA//ZNVxLiRdemBRDd5dQXdF+wo8pFr8pmsSOp/xradPi9Eo/
	gTlxgVtQQGXx9Hhq6uPOKw4F8cT3UMO7nNYBH1QtW3X/VOZN6PI9kX6oIYZJiLI=
X-Received: by 2002:a05:600c:34cb:b0:48e:6db3:ff3a with SMTP id
 5b1f17b1804b1-490c25b09a2mr318277935e9.16.1780992702020; Tue, 09 Jun 2026
 01:11:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260605031008.397328-1-kunwu.chan@linux.dev> <20260606005431.89186-1-sj@kernel.org>
In-Reply-To: <20260606005431.89186-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 9 Jun 2026 16:11:30 +0800
X-Gm-Features: AVVi8CdH0juoNThKREsErMsXdOM9cAvNHpugD-3PSlQpcq7Fci8WlqM2nwe8H74
Message-ID: <CAN_Opa8sqs-V-jFrGZa6jwJKdHqT=7JPeLKcU8E-cCM74ON4DA@mail.gmail.com>
Subject: Re: [PATCH] Docs/damon: add TLB flush policy document
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Wang Lian <lianux.mm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s5jha18eoy74peemdc4j7moxizzrssfb
X-Rspamd-Queue-Id: BB1C1C0008
X-HE-Tag: 1780992703-902649
X-HE-Meta: U2FsdGVkX1+sQhp6nW9OWkM3cOHDsjxCiqonE0FvnJVSo2K81y8nDslqr01wac5G9OaonxHaWOq4TSKI6xRUWSc5NWyvJrIaBM3Qj35+uUCshYXQThau7Nii4upWliMXIzOlXs7EWPGceUPtOHVtaDsOJSzejEyuKXTSLIM3DYYwWRy6FAbkX74sBkeOwLVGmcBNLj/WZuADgCaPXRnKQeDDJfBTomjrjxwvMsGFjAFw5Y4x077cwWYwS8gQM/nNAM0GxS5DHlniSkve9NLnCls+NhkMsSJsQvIi4gg2pSfo20h2skfR4ILPgGr3i+FpOGx+HvPs2+2KtdV8s1DFIHSud3664NoyuYAeT/iBDNZevV/oARg0SLpgf6stcddtc1mo92+/lwPl4MDR+u7jm0Ws6TPpvvbfxZwjbF7QuCKDiADBM8HnIcIOVwIl9nnpLKoc6nR9PY9hK4IN5LW2UOfHAj5dH4S7PRCmodedjmAoFTTb/QRBm7vWIw2Zvwajnpwq416dI5NKo8QD+euqMMv6QKWGYikbfNTJs+c1APmhUSF9bHJdxMIsVV/no1qakNtE7UKnSC1O2qLWuZYJ5Ijd5EuMRKQPJgaR2oLQurIYaUn8XC42eQazr4En3nV9abf30I9HcvK433aQKdD6Y3UPGmL0nCMayei+i/n4GleNZW7HOlDqi+xmV5KBLMe5P4k986sJ0AFcCJdHF6b2GnKXgs9+PtQ6IzRi0Y+WDvQHPfBNppLJth5G8qH+2MN9MNdPj4zDEDpXH1FRLnEJtZAI6DIpPNtUtncC4sWqobDGpwxkd8fjsNuTaV2l9BIT6DOe8S73MvF8WjtQUgWaP2RGu/xerdDULEYiMTDykYS1+Kd+CcYD9dJRtafqOSORpnIoNa0dYWQPWiVxKBSKTAY5kbmjiISx9EX3UfdMRY+gnxOIStbvI/pUdR/+9qWyPNR8iqXLC2lmlXBxTsi
 BULkmBHO
 /zwuj/qTWKwTN51y2Kqka3fi04p/ViTsn5EKvhNK3uOMKMOfqGK97jzT+kGZqkSXDrFYoUZpjZXt417TsyyqPqAtDAB0Fq1ndBi8H5/1my4Sa5VaklLw2MMyOMRKENLsAXPBA4+BP2yrL4BSd4MJF3HUEvD9Q9hj03VLYd0EC0WnN3l8jCEn0fKKry0suKVsvy+5EsKfvrB4RKD/jKs7Rv/OrYreHEVbpOOsJ51xyuHEJWyfkut6ct2aE4rLyaEpK3JbI4HCT+49ifAzIAT3lmQtvwQP9Tn1q9KdEYAcGFM4yn74mXwlMz33J4kBM/mUikqIfP6wjVB2Wzl8l+gRRxXrSnl/FrhQQsbgBa4GCR8LP7ZU39nv0/AI8/bDadZEiiCjveOrblvvtHOu6O5ys6oz4PoupCzGA+7AlAnUaDG1iyQkfcYETHgY+iWR9WSzNk8Hn2QS9KjEQWBn5t8OZ2O2jrhg7+v6hWmmQb2RZ6/68aD77nR/LNGUscNDJH2mrC7Jb9FE1GB3Na0+lassFhB0wDP6LK4+GHvG1OBWrQLJQeW/LpMzRNYKjXCBRExalbgu99u0ufO6kixlYxAiGpAjU80JWv+9HktAfq22rLikVh11onUrjmpC7oEFT6qgEBs0CHv0TZYhyW/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 6, 2026 at 8:54=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Hi Kunwu and Lian,
>
> On Fri,  5 Jun 2026 11:10:08 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > From: Kunwu Chan <kunwu.chan@gmail.com>
> >
> > DAMON avoids TLB flushes after clearing PTE Accessed bits for sampling.
> > The overhead was measured and found significant [1].  Production
> > workloads with large working sets flush TLB buffers naturally, so
> > accuracy impact is negligible.
> >
> > On systems with large TLB buffers and small test workloads, stale TLB
> > entries persist across sampling intervals and produce false negatives.
> > This comes up repeatedly on the mailing list and in private inquiries
> > [2][3].
> >
> > Add a document on the design decision, trade-offs, test environment
> > problems, and recommendations.
> >
> > Link: https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com =
[1]
> > Link: https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org [2]
> > Link: https://lore.kernel.org/all/20260526145034.91594-1-sj@kernel.org =
[3]
>
> Thank you for this great patch!
>
> >
> > Co-developed-by: Wang Lian <lianux.mm@gmail.com>
> > Signed-off-by: Wang Lian <lianux.mm@gmail.com>
> > Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> > ---
> >  Documentation/mm/damon/index.rst     |   1 +
> >  Documentation/mm/damon/tlb_flush.rst | 131 +++++++++++++++++++++++++++
> >  2 files changed, 132 insertions(+)
> >  create mode 100644 Documentation/mm/damon/tlb_flush.rst
> >
> > diff --git a/Documentation/mm/damon/index.rst b/Documentation/mm/damon/=
index.rst
> > index 318f6a7bfea4..5e239437dab3 100644
> > --- a/Documentation/mm/damon/index.rst
> > +++ b/Documentation/mm/damon/index.rst
> > @@ -19,6 +19,7 @@ DAMON is a Linux kernel subsystem for efficient :ref:=
`data access monitoring
> >
> >     faq
> >     design
> > +   tlb_flush
> >     api
> >     maintainer-profile
> >
> > diff --git a/Documentation/mm/damon/tlb_flush.rst b/Documentation/mm/da=
mon/tlb_flush.rst
> > new file mode 100644
> [...]
>
> Great document!  That said, it feels like a good complete article or a pa=
per,
> rather than DAMON documentation that pursue to be short and essential.  I=
 feel
> like this fit more to be published in a blog like DAMON project blog [1],=
 or
> news site like LWN.  If you'd like to, please feel free to upload a PR or=
 send
> patch for DAMON project blog source [2].
>
> Mainly due to the verbosity, as I above mentionedd, I'm not sure if the c=
urrent
> shape of this patch is the best to be merged as is.  I also find the back=
ground
> part of the document is a kind of duplicate of some information in design=
.rst.
> What about putting only essential information in a condensed way on the
> design.rst?
>
Thanks, SJ. I agree =E2=80=94 this document reads more like an article than=
 short docs.

I'll follow your suggestion and submit it as a blog post to the DAMON
project blog instead.

Will send a PR to [2] soon. Thanks for the clear guidance.

> [1] https://damonitor.github.io/site_about
> [2] https://github.com/damonitor/damonitor.github.io/tree/master/blog_src
>
>
> Thanks,
> SJ
>
> [...]

