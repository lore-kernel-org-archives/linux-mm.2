Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B9AC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82C56B008C; Fri, 18 Sep 2026 04:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33CE6B0092; Fri, 18 Sep 2026 04:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23D16B0093; Fri, 18 Sep 2026 04:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81BF76B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:20:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EE881205EF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:20:42 +0000 (UTC)
X-FDA: 85226186724.24.EA8CE88
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1F13F20009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:20:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cPAT5PBc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789719640;
	b=c35+JuCxf/bCVLF+1aXm9XhjWL2JGYFF75u92JWfGlcIkwqmK103eHugCKRFxBeCdXATtW
	iRQb3nq22ZxlkVSat9oNEP2OuFQ4sMKjroYZCgO5tXfTVG+hTYvH3H+qxZqM7Y/iAmYZ6r
	9yCyTKsRDgHhBTxQmu+zx1ZynqJ1d54=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cPAT5PBc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789719640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/0xeeqml62b4hzIs2sGIOyHX0Y352/7mh8gz6dinRs=;
	b=UoIY5ccCOFCrHiKQhhWkNjh3cIQ3sV2yNapaYUXWnkssBfA0SXmcHfgVQW+Pv0I07NbNrG
	heVMGoN9ZM+8ay3AymxdapHelXa/Y6Rgp7PgQGlSkrSpkAJJMEbBQzSOmEUbGDrxN2W2FM
	AWGMs+paUanuBHugqgYaIr6jKBMsagk=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso3227875e9.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789719639; cv=none;
        d=google.com; s=arc-20260327;
        b=aIMAjfXu1CuzFriUEXRfJKPHkCqhlwFEEIr8xKO2WhLCc00V+byWjgtfFOUXF+3hQF
         pOR8zdFDxv36sAuKDTituXddscgfuOKAD0Qv9OsV/s94aSpv477EDc1VaJ3x/aULOm3m
         d1j0vp3SiqxTC+08oLU6AoHs687UoZo+/yChsixx6ukfDt48iq2xDxD2Mx7BMZXV51F8
         vryao+xgx4/yZvzfYDuWmYrejD6pAP6xUR9lx2LN+fZDBkA+BQpXT8xEwlsXwoveVcNS
         gEca39uF+yM/wYdajwCRAd893RLlOuOgLliJG/Ejrb8CZu2TX68Q4vlArXIGJNiNMHf2
         JB8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S/0xeeqml62b4hzIs2sGIOyHX0Y352/7mh8gz6dinRs=;
        fh=CEdrlaoyfZNZJcusYchhc6Pf+eLIpRU3wvMpgzoYxD8=;
        b=rEwPUmgB5gc79u+YPTWmFzUoY99oeFLhXW6/obPHz3ezSJX5Irtqsq9zqV8h50iCrE
         NYQ1tfeoMiUgrYuvCQ5TvEXhhByXx+oO2DGJTXCispySmdzwxPY333dD6e5K/jLd2yl2
         DpLc/HQrQvto0ABOSMRu531p8bkqkIf0Kv2EuBDwswdhOQan5HxiSaVXYzzlP/7dOCuI
         fpfse77bEsAF31tLFxNjCmGF4TntFEAL5gHt3FpBxzdl5Xy6PvTeWt2rrUWn+x8zLaIF
         j+/sWJzr0E8FKIaaCvUNXxOn2O5mimnElkF90qjIcEtNf1kbAiTPA9ri/6CJ+IToANEN
         rR6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789719639; x=1790324439; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S/0xeeqml62b4hzIs2sGIOyHX0Y352/7mh8gz6dinRs=;
        b=cPAT5PBcVhyyMMy5cqGhv8VH1vQSGIBgJD6bUSqD10a8kV4T+Wpz5UQy9rkgprGRv8
         t5PXWKUlmgjF4wTfoloOWtSDwPkNxmQONqwe1Gui/L8nahJm8b9Uv2PHPOo8CiktZUYu
         fImRgQVr6p0rzFsFF9Eobk5WmIrj1P/siZ+ofKPVfmOyxTbFZdAQUl9SuUy4sWjY/asp
         ZBjM1u6r+7PhCVbvuSyZX/gzR7DUBi1hD2iQWeS2IUhUmsOJDJlI4TThpxBlCpKe+m1J
         04ABXwHDaVNqNsKjb2Qb/wrEyD2BtuCyV+sX/6V2JAbhkbDjTtFFUXCNxhPPUOsxXRF3
         GVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789719639; x=1790324439;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S/0xeeqml62b4hzIs2sGIOyHX0Y352/7mh8gz6dinRs=;
        b=pPdpm76JFpRB5NWU7bdmzeWiuhVTppmNq9y54BJ8M4c2IkGW/u+YMuTi5GhX4S9VFy
         YgG/31vEq8Q4aDO8kejYK8D7Q4pkhnzBZKFBIeRDNoVDEwsC0yZCr2fMN+gL/3TPZ4/m
         kPBJ7Ka0RwYcjemlkm6uFjQj1Zxe3N6iJhNsiDbIv4Fb2gbtR4E3sh0TxmWngxRMBcz+
         Pgbdo83Nvnpuol2wN9rnlAazLGJoTEWcHRUPDzlVaDL0DX515xQFFFk5T9XYJm44p4Bg
         MtUdxU4CQI70oauwgrBbet8am0D9foe82b+jkSSll8BbElH37x4jsa6DVDTEbxq2PEAc
         htkw==
X-Forwarded-Encrypted: i=1; AKwUvBy2fekmyYZO2uybqGQ3VngcFUpYHHSBHOWD7BhVEZcy0vsSnS4t5m6rYM5xfYH5QBoib80xHTC/pA==@kvack.org
X-Gm-Message-State: AFuF++k3JaQv7QGn6J7+GN/NZTFKe8UOi5bSufzgwtJOsS8pIRGjoYAI
	c50m42UTPch3qyUKuWzZ9mim8I/D5N0Rtp4Idc58Qcn7l2FedpyqiTs5mVwzdEqp3M6RKxx6J4R
	bh4MZ+0GFNfdXHONgNQjDrGepvA8XcfY=
X-Gm-Gg: AYBFou039PHJVmbzszAMy08FdhlmVTK2I6sIHgn+dqgUaAs6aoba3xMfWjVMko50NCL
	YZ24/ebbQbfcK0Q/t8b1JPLT4lhtFZbtqghs7KR+DWa3BS1DY0/Y/0xS2tDjPmgK/6SkzSbgFdP
	jbA27f8S+P1y6R13Tv4SfG2OUQ0ZIAYcFgLivYRulDrmVEKVBETKqsoIcBH6RRAFqGc0bwGESfi
	2F0EjUX5aCGWGlTL1iJSQZ2k25FtV5Ht31ibcE55oTwI917Nh4KoQZoQh2l5dgZK1oqbVAYHoHl
	d2RA0hBD80u0sF7vqFRSMSxjDv8Pd+SDFP2YvhNqu9KeQsxTg7jmIr6b
X-Received: by 2002:a05:600c:3493:b0:49f:bd3c:bc21 with SMTP id
 5b1f17b1804b1-49fc573b55emr19996295e9.28.1789719638568; Fri, 18 Sep 2026
 01:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
 <20260917052933.188679-3-jiangwenxiaomi@gmail.com> <CAGsJ_4wDbDLv5mxfNiyraOS6tKCSV+g8xL5+SsRCyqLnN2ON7A@mail.gmail.com>
In-Reply-To: <CAGsJ_4wDbDLv5mxfNiyraOS6tKCSV+g8xL5+SsRCyqLnN2ON7A@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Fri, 18 Sep 2026 16:20:26 +0800
X-Gm-Features: AcwNN1UdGEZgXXaGyHc-WLWsn9JkWUJTL9ur_osaBhDBGn4esHyfsGM8b6arOrw
Message-ID: <CAHKocdFCuFR-gYCrY-c0iRKZ2GRZJCnTJjHGe_TvMoYkjnb7aw@mail.gmail.com>
Subject: Re: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1F13F20009
X-Stat-Signature: rwgowdycaoof45o8gykgd4jis6d7z5ns
X-HE-Tag: 1789719639-388265
X-HE-Meta: U2FsdGVkX1+5ahqHm+82NTwCSYUoBnEOSHDPGe/fyKEIF/zNvJ9sez8CD1MlrzN30uFG2JwW1dOj0xloX5AfZz8kAmjqJsR3+r6wrKeQSR78V4spovB5UNpTtMT1BZFbo6Be39/RxJRSgKkNv19MPRLMaP8V8fAioPexVykOgYVsNOkOZCsRVicxhvsY1PuPYELSdcKpyZPb715c5qUUqPJXwC22nJ2xEbs8rWm0AK74NKyI/B8Wus40PHgr4ILJWwVrrSZl8SXWX2wuxOFXt87Boh/mw8MhZdTSuUJrZv1vAWocYSv/xMTi0TRM/sBoJl3LyDUfZH8fPtJKF+2N6nKvyN3Dlwp33e8awCFWMc7MU3mMg39kUBW/pwlmax7CvkEBG0sx1YmMJSlXwSZjMlajf6beYskLI4Jd+teVzy0DzlK5+sGCw5bfzxvd2V+HEKd7Qt15kZ3n00VBSpkZ7tyiYqpxzKN1llPEHLsbsrRbJtrHv6Yv4bIh4qAHc9iQa4XhSeToxnWhnPlWWijhYp02ZLcU37qnxfdhzXWbk6CfKr8Gs0renAHQC9cbyV5bRkReIUjlaYn1ZStU5brVujpfubFJBRUzrgwYc4PJ6lb8fdjx3gT4t/RhJpaVrbD0pAE/ewrvd/L2AjI5w0vNDcUJrzuqgLwnemM+DiTGzZuvr2ODyotucSsfEHnAbHGu9Asi+6v24Rx/Sgc6w1c93u0rqn9+NiLWXhRgoJVyvU5IESC+FcO7HReouT6Bed9VZ7TV7fB+c5UCR1lyS2SiEU3Wu3xh4GepiYTAD9ALUiGRV9lYMLuPl8tNe7R7DlrwcxbVtI9S1dK0G5U7A+vCajLN6IdxD2Zb2/R5AOvU0nHMXQxuWD2j9uMrGUaM9zbyNknRA3C9cfdpxJN90Tk+LeZjkPCYkG2D0x4yvowTtP7Zqo0LQRzAJVcp6d4tYBsdci1MjMGk8RDzN2ehFNR
 evDKCWp1
 ryHOzaYYp5F77rYBrBv6RAw/+pwgxC8tK7NWs10maJjJTDsRthllXvp5zfrRIIs8U2E4VXrZN8jcsmq3FIatgNf7eOEn13kIAOJPEdKxlmxuVI2YpaxN7CZtcIzcrzEiIfvwNcacuTu8WNASV/No90SZCsV88B9ESBxrAu2GmQzTcXmHI3YeyPpBI0dqbGEHXR+qOM2gHgkO1ddlbkqlXwpInExIC4vYwUElEV6W/QlsbC1PIGgB4HkMieDwm2qO9cC/4Am3wnJDYKyIsjlunFfraaKwvbCD3KY6VKlAxR2PdL/CVOiX08wn8Rb3hasRNw3RAN/J9OEUf2T/p2U8/bxOf3AxT4NF6goTzYm/YiEG1e63fbPTTzTZli3nXLDt99f5ITP1gaBApTK7nSE/lZTSHLnNvyBPnj9QyTPzsvuT64fTUoSNnlXKDs2AyvaIQQX6dmyHA1W0ABK4/7krUdEt9Faw+hQW49J74JhEBAHwJt+n7LWfc2Ssc5yO1+bkYJTUH1FwzEivvATV7R89KVWSgr+/n5BW3XJRGNk5E03Pu48puP0R1t1ejTt0BhFsR3ZSK7MFv+9Nu6T4zMDq2E0NFMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sept 2026 at 07:28, Barry Song <baohua@kernel.org> wrote:
>
> On Thu, Sep 17, 2026 at 1:30=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.c=
om> wrote:
> >
> > From: Wen Jiang <jiangwen6@xiaomi.com>
> >
> > vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
> > by reusing set_huge_pte_at(), a HugeTLB helper gated by
> > CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
> > CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c to HugeTLB
> > internals it does not otherwise need.
> >
> > Add pte_set_huge() to powerpc/8xx, next to the existing
> > pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the hug=
e
> > PTE and writes it into the backing cells directly, without going throug=
h
> > set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.
> >
> > No pte_clear_huge() is needed: 8xx does not implement
> > arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes th=
e
> > block-mapping branch.
>
> I assume you mean the block-unmapping (or PTE-clearing) branch.
> Please make this clear in the changelog.
>

Sure. Will fix it.

Thanks,
Wen

> >
> > In practice PPC_8xx selects HUGETLBFS unconditionally, so
> > CONFIG_HUGETLB_PAGE=3Dn does not occur there today; this is a decouplin=
g
> > cleanup rather than a new configuration.
> >
> > There is no caller yet: mm/vmalloc.c is converted later in this series,
> > once the generic fallbacks are in place.
> >
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > ---
>
> BTW, this patch applies cleanly to the mm-new branch.
>
> Best Regards
> Barry

