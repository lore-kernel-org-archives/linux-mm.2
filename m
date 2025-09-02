Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5E4CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09CD88E0034; Tue,  2 Sep 2025 12:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074DE8E0002; Tue,  2 Sep 2025 12:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCC98E0034; Tue,  2 Sep 2025 12:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC9978E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:06:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8969784F72
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:06:22 +0000 (UTC)
X-FDA: 83844787404.28.973400C
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 98541100005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:06:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BLw8UKOd;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756829180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IzANuyEuI1RP0uICgM6hjPd4IH6cBKzDDVGFb2HLC+A=;
	b=v8M5voNcsNNm6ePDSkCFgPqnFu0+WqHb8YF8wpdHwTPTeTAYmB1pkXE7dbQtPn7sUUEUUx
	g+sVNcEy06Hj0UgYKTlrLW+ciYWKH5CtSDhh+VvE7rgYyl+6Hoz6MgKeqO8LPQ5828Elxj
	yfFwYy1UCctYivcPGsNw/69T2WJRECo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BLw8UKOd;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756829180; a=rsa-sha256;
	cv=none;
	b=Vn8+tr+Ar02mJgDuFit+1YgSDumcnAe80K3W9SAjOOR6fxppiF5SzZiZmR3GgB+MHUXP98
	ybcb6uy6i+r2mxoYdCM54KAq7tGtRB6iprC5B8NHrZSEZE5OneOY6YRVf1xh7zmU1By8G9
	1u9ZgKnGNVucU0QtcF/3+C2sZ9laOnI=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61ed395ba46so2565a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756829179; x=1757433979; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzANuyEuI1RP0uICgM6hjPd4IH6cBKzDDVGFb2HLC+A=;
        b=BLw8UKOdSggT0dWYzEcGH9K40W1WblmeI5dysWFc55vfin5BebL07oRW669jWPxTpd
         UVbS3Lu9cZeAuvj0rFdK9YLo/6Xs2+Qo7aDctp1ahvcjIG1LduujzEM1QynX80K1O30v
         S/Y7NliIJrjAcDW/cE3yPnSnEN0M2or0WmWxhfmrIOFTsdsnGRz9QZw4acjINMBkbm/f
         8DkuCr2tvwHfiZZx5cBOEmbc2nrFg00z1tV0n0kQN0qmOzAH57nkkyerXc8nr3iHW3tp
         +9G3GviuZP9je4035c6OL+nw8KrS7aYt4ToaMRH2elINY/T1sHY9iRPZnm1I2aZg68dU
         YjVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756829179; x=1757433979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzANuyEuI1RP0uICgM6hjPd4IH6cBKzDDVGFb2HLC+A=;
        b=MDbetaHwV5v+PAExv9qus8dwgU/l8KFdnqeIz9ZatXHxoWhaWTAD5NLI8CzGmO/I5f
         /avLxMi3wjKufmhe2lCmQTPle2QFw0K8/wdIDvPGEFWcAg/d7Lg7qnuBNUMQi7TYvWaF
         j5yHmSaLsgNNAaLqtM6uY1ghcCZ/3lQCWS0cXT/6Ti3gme24xLik6iqoLkThHr/Khy4s
         09ZcnIw1abAR2emYNtAkcpmIhjTiu94AMLR1v9Xhg2UIiNQJDfBo2dDmungaLJCiRv6h
         WGxj+zaCrm7zgn5fg6jXgaCJlEQWcjWASe5zat3STZ2yee4f/QfXNaBWPo1+u/5ACwO5
         +cuA==
X-Forwarded-Encrypted: i=1; AJvYcCW2EZ36UyucFiidFTDH38p+PfEJ0CuAJPvktYFnCxqi+S7aU6KF2sgYYllmz4G19OxNIycUws7EdA==@kvack.org
X-Gm-Message-State: AOJu0Yz+hnG/zqTWfFsgBeztBNC0+3Qxd96rmY/mYLeaAAD7Cx5hEYmJ
	yfqUSkrcgffGO/tODzINw8R+qqVKCno6yFq5QqZ23riHEDj1Wp1JssB8lib+j/jbu+4hgkbcJGm
	89/fUwWccBtDypLdup5ulI4UbSpACyat3+8bp48Mi
X-Gm-Gg: ASbGncto3O9T+/5sD6w8KSCyphLIRrATUHI27slfCvjdju4iRpiZuEYdiKnypPKoC3I
	A8zUBaMnzxK32PTyFgjI7UURERw06FzeiKwUWEU4DsWjsV4U8aDp2tRsbbwataJwyiFBXiboJAY
	Js195ziJVWCH0AppWrnHJbiCCYrtPK3P+DEftTxOt6FSYFtPZMayJN84/aH1uHawIiPQgEVreQc
	jp7zFpY/q2E2p/rmBgMdOZ+/dfM9YButZYUD7PXPfPI6Kw/IgTf
X-Google-Smtp-Source: AGHT+IFVjdQ+2T7/LXpZCpOfk33GaA9SF6xBIIl71Fs9cHt3AeFCESliSAH3aiD8Kxte9Rt8Kym9K8NUgZg1oMEq0VE=
X-Received: by 2002:aa7:df92:0:b0:61c:ab1b:1828 with SMTP id
 4fb4d7f45d1cf-61d21f9fc51mr262090a12.7.1756829178846; Tue, 02 Sep 2025
 09:06:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250226030129.530345-1-riel@surriel.com> <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
In-Reply-To: <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 2 Sep 2025 18:05:42 +0200
X-Gm-Features: Ac12FXwEw7Qk0kLzRMa95Y1yUaklA4c8qD40uRP3S8PLdE1A0rat-HccquoTMss
Message-ID: <CAG48ez1q_Sgk5nr7Bngyt0UB3FkYb6e0cHv18wqD=sLEdrZkmw@mail.gmail.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Rik van Riel <riel@surriel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	bp@alien8.de, peterz@infradead.org, dave.hansen@linux.intel.com, 
	zhengqi.arch@bytedance.com, nadav.amit@gmail.com, thomas.lendacky@amd.com, 
	kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org, 
	jackmanb@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com, 
	Manali.Shukla@amd.com, mingo@kernel.org, Dave Hansen <dave.hansen@intel.com>, 
	baolu.lu@intel.com, david.guckian@intel.com, damian.muszynski@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: srnuq6jne9m3nmttryj7jz3ht36rfz8p
X-Rspam-User: 
X-Rspamd-Queue-Id: 98541100005
X-Rspamd-Server: rspam05
X-HE-Tag: 1756829180-166535
X-HE-Meta: U2FsdGVkX1+GnRcfkbGQfq5IFEWc8d2c/msOD5NYr34KM6pTW/DtICD5QKUgCN6ZtJkTwMiF2XdQmjgtaekDQEzw7NvCc9b6Bvthj7iW/sCQzqMBL1NVFyeA3G/ImrjwGebsOg7u9+9cBJ/YYI2XO+oRR0WIEVrraw0232HH4+BHa1XiTnbKH3RmAIASmuSdPHCTGKHnLZdy22/Ue9vtpwLFUlVDT6rK1szEK2yLrFytJWjCAv2uw8cDnc8LKZzL85rMT0jaaNJEEjUD8D7+WrrAtqwYo5NLV4rVdrD3Wp3JNYJt7iK07qf8xYSoz/6gwI57UquSJRgvJ+GP9qBDm9EwOqXKvVwcWemog1c8kIreT6bwWH/5pIoSTQ1q6lRfB536x99ou+LP1u7+Qtk3NDf+tbiaa3/uKHKRV+6H8Abm1BNgMO8y+CwOCaW6fZWbxJvpOG3z0id5dNmWyxlwvq9+SKlSjbpyrH92xJTLmvt4WSRmFj2vLcd/MpjoAhiceodZp42zO4sG1SvbUamQA979O+Bx6ccbKR1GWX4YvqrF52isXpeXB41Ie6HzaReyOtc5uELMD4rr3BASUgTb2rD/ZuL+DkM6/yobUNLEHsiiYRyVZ2vUXCoxg34eBb0f7bQGJBRHvvDekCGR0fUX65zQxcBl3fKYSZBIwWISqwG7w554aK21dFEhnCDaBkURPwBXcpmB6yyqrys1/BK2Mj2qnfq6hI4u2tbcAPVeboeldidyveFLZU6d/sx3sMPm0GdL+fjvu9u6dCVvZrTk0fWvAD8kq1kY08GM7YoLtYWCOle79o6H6ccWDoyQnQLXEUg1mW27FHrJ6sIamCgGnKseSEK6ZiI4BIPlskrEnx8jguhn6oz5aq4PGZXvhJL5JKdflBtFPyZCOrn55TVW0KxSYxEFLj1TXQoNlKl51Jv/30x9ssaFIjJqBd2kyD9o+E9ui5IYlKZFfjyJk+w
 gYkfR13g
 MGg1yo38VkEqDesTUdIZTlG31pGw3+Q5L1SRUdvtPcFY83SEESla42fW2kK1bXaknIYfRRE87lSo66lU+iOar8rACKo0Wrxuuv34YQXrUU46edpTUbG23CGNNIaqjQ6HQcljXu23DumnuyAccUQmX0uCk/NoYLqodE34U4RiKgsCR6ox44BWzl+gblnm5Gzxrlyu3bQNrnSWDcJ2pXfxFq+Dn2HdEM1Iwt06yzv6CESoFj2CY5BjQ1EqUkzMnM2NaPl37D9XlvWCFhEd64RG4WioSbBkVqc/6EzyS8H8YNyOIdDl6ZZpjDixs+HmOBOzJnPyk0j+LcJ12cOtZ6+tq4E5E7woGlD45oULEurtw4QnQkTfg01yeExYm2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 5:44=E2=80=AFPM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
> On Tue, Feb 25, 2025 at 10:00:36PM -0500, Rik van Riel wrote:
> > Reduce code duplication by consolidating the decision point
> > for whether to do individual invalidations or a full flush
> > inside get_flush_tlb_info.
> >
> > Signed-off-by: Rik van Riel <riel@surriel.com>
> > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > Tested-by: Michael Kelley <mhklinux@outlook.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> > ---
> After 4a02ed8e1cc3 ("x86/mm: Consolidate full flush threshold
> decision"), we've seen data corruption in DMAd buffers when testing SVA.
>
> From our preliminary analysis, it appears that get_flush_tlb_info()
> modifies the start and end parameters for full TLB flushes (setting
> start=3D0, end=3DTLB_FLUSH_ALL). However, the MMU notifier call at the en=
d
> of the function still uses the original parameters instead of the
> updated info->start and info->end.
>
> The change below appears to solve the problem, however we are not sure if
> this is the right way to fix the problem.
>
> ----8<----
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 39f80111e6f1..e66c7662c254 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -1459,7 +1459,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsig=
ned long start,
>
>         put_flush_tlb_info();
>         put_cpu();
> -       mmu_notifier_arch_invalidate_secondary_tlbs(mm, start, end);
> +       mmu_notifier_arch_invalidate_secondary_tlbs(mm, info->start, info=
->end);
>  }

I don't see why the IOMMU flush should be broadened just because the
CPU flush got broadened.

On x86, IOMMU flushes happen from arch_tlbbatch_add_pending() and
flush_tlb_mm_range(); the IOMMU folks might know better, but as far as
I know, there is nothing that elides IOMMU flushes depending on the
state of X86-internal flush generation tracking or such.

To me this looks like a change that is correct but makes it easier to
hit IOMMU flushing issues in other places.

Are you encountering these issues on an Intel system or an AMD system?

