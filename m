Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9243B606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TV3rIPRT
Received: by kanga.kvack.org (Postfix)
	id 8C88A6B05B6; Wed, 11 Nov 2026 19:31:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879CB6B05B7; Wed, 11 Nov 2026 19:31:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769746B05B8; Wed, 11 Nov 2026 19:31:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48EDC6B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5A43120457
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:04 +0000 (UTC)
X-FDA: 85424587248.11.CED5E58
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6F43C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TV3rIPRT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6u9+23TRytDuYgPE46LNdROZdeRwOWR2OfnIkWa60H4=;
	b=NNumUwR5sN9ec/LTHKWAYBXFmdOCx14d8LLpIBHv5rcjiMzuKU+mw2aB278kAEaM9WLuDM
	ca8QV/gq8z/Et0iK7jO5JX7XO1BENuC6p96HYe+7vrZHlMRls88Pwu8pnoYNxBBHg0Zsma
	1ECuUQg6pnOFeV3uieZldGjIIPPuGxY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TV3rIPRT;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794443462;
	b=NgJcRMnTT/IZvbsIGyKURi/xecUOac5R1hpQT/J4sZgZ11CUQ6HD9t4MHYTfvpH6J4ACG7
	9aLdeBWTfzN4OhjWo53U80lePnrPB/lRhPaqPC1I5ZryKtpO7L1z+unB9q8m3OPjj3Rs+i
	Ak1onnd2vWZSG5on9XcNKHtSXGMds90=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5383c97c8cfso41741cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794443462; cv=none;
        d=google.com; s=arc-20260327;
        b=YcCbZAMjSzBq+3T8c6Hzp1UaWeJpnq4rOcM5/o0RIcaQEv07SEpQD7PoLTQuJsxnKE
         3Pp3O4vghRre6m6k2xWPtsnlekonDWOYWbIR6/JFh3qyqhrnGUHPXmdltUFkpMu4Mdzl
         ZwT2a/0lSY3nqIyZEQOMER0rUD3ElPfjD8mOoy+L0sQa9ocq80zzLXbpYI1SW/iJqcTz
         kil6euRbZ4QOZIe8+uCkkOvuix8mY4PGVYPZoPSI4caoT4/JpZKrRyaYRHBY3YRlvxty
         cZA3xZujeXMXXH3/ibH1ba5WV30RyjE25p3y/NJP8wgoSHFEhOrzdqgRRtxnKRngWTnm
         6LXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6u9+23TRytDuYgPE46LNdROZdeRwOWR2OfnIkWa60H4=;
        fh=RyD1Nbql0tKj0e9mkojDwmi8DjI5kfvl/+kYzPTEiKw=;
        b=bAsCUq9achqD15YCkD/y+8MRL6GAVBhNMe6LZzZNjWgZ+dNhmMssItxRkBR/dVaoA4
         MdTMG0pSrFSplXN3ctjQfwoTUdvY+FXX3/KYvQxb2d/4F4Bf8aRUADq02sXEAMCyiDQs
         scFJ+KMbbqlrTZ4+rcAYYmuGEP7/mGe2PZH2nNkyicNbL71F9B7bEwS5oMywQNJuHFU0
         NYX81S2Ycj4WOL7QXkBtysjpRcIR1p4r/Vu3wmT1xUfiKyp0IFWAxxquYpZha5Ugb/lh
         7BvE+riEDq1f0ffNmn8EuPqnAP7E3KETlYku74uBIMaRBAq1HPWiuPAzFxtqdxoO29ga
         DaJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794443462; x=1795048262; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6u9+23TRytDuYgPE46LNdROZdeRwOWR2OfnIkWa60H4=;
        b=TV3rIPRTY0XvKDTxQxBVAIIBBJR1vdHql5KF/TL4ya640mhlyG9Bn7EXYIZKPV4VPq
         Blw1zbA1spNfTYP/aFa6lMTOtJKF1chRSvDtCybqXiMGnqtFA4hdKBs1Mejl2nnAVZkZ
         vNqR/U2OZG9gpNWsxeHGb94gJamgpznqRAbrhLD0aUbDFPVWHU4InqRBLXEnlhWOYKT7
         rLpUnno507gRWX3VNtI0nhJIwr85376rBRde72LpaWT8MltsL09nHfqGKZArQF9deENN
         Hr2+s34doJ4cnVYbxPoj2DnTDqaXU4zlpdhKyHpTOwFSwGpvSMgYgBZBK+ZeQ5yDafra
         xOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794443462; x=1795048262;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6u9+23TRytDuYgPE46LNdROZdeRwOWR2OfnIkWa60H4=;
        b=NbCHzbZKwlaiAdW3+geEVR8GmDv7wrPDf4S+0xpw9g+84l5V1Jbf8mg89RVHfX6zq8
         J2Nr0ArPaYVuyLqaABTP7kWLpOdw8wld97jCz1NaXsndDzBvIdEbJwKKcqlK78EktfZj
         ePHVvpSbYVVlbVehpQkmINAH+XV2AJMAiZs3HSFyjBS3c+Zzwln/t5C9SeO6h5cRFSLR
         s/qehUxeQ4GQO9Ijhm7XfASbuaJ1IUIEZL484UxOxjIc1RelhWaVOrHoh2BR+29ZjN1x
         QA3X/Ld7aD4fG3reuc512yeCNej/BoZaoQ+AXbBZMO5/qGfBGLo4kMXGXcUYL2KqdH6u
         IgTg==
X-Forwarded-Encrypted: i=1; AL+hErG8SCy/OgdhRKnd+PRgKYok4H8Qc9FGa31s6Qg2Eull60tqT640Np8y6srSaGDSB2f+m1ztpKqRbA==@kvack.org
X-Gm-Message-State: APuU4Z9s+xtDmwrVrYLD0j/EHT7DDpLy65+iDdtpd3hzpgzEv/PyJUAK
	zMZcBywGDgdUyIWBARMCiJ2PZLkZpjfuVN+nzHqTIDt072Z0OPC/NVyQRmbgziHS9lqJTwfKnDR
	EAIl/Uz1iJm1f+n5kf3YjR5WcS3bFRkboW0M1NUw0
X-Gm-Gg: AYBFou2vFLtr7S/oWTFDKxSDAYMcZe3D4bKcXW80gtAqB/E95jE9LtrGC4o+i51cF2J
	sUJHKJNnAonoYJlUVuaPbI0k8O9Upl3V771Qc5zezFn1od4QHy3erHhf7iX1ZTA4BmibHM2eC+j
	THGIRrswKzbEX6L8RteemE2W/aqxeYZ9xpP/dUaSVjskpzSv3IIeQldEV1dlGTSz6eCWIjQtaDn
	zS4roJNkUdeWb2nROm+N6DWDluhcaLSLE542xPrygXtba0lVcAH5kX06Bo3rG6p9T2HYpm/ImcS
	Ojaca8oILxMCOKC3K0kwOTzoTBUcaKokYD5hP5v6mQmazJ3C6uh/opxawO/kofy1sLsbuQQSldp
	rV6xwSkiBC8T8yWIDjYFHoN+QXMkMm2g6+oAE4fzH6pZD65be/aE0dBgerA3g17cQXGWiBtJKsN
	p3FDVQyeiPbU+zYno33y52F0wE
X-Received: by 2002:a05:622a:5597:b0:536:6d88:600a with SMTP id
 d75a77b69052e-5598fa68ba7mr5286631cf.9.1794443461135; Wed, 11 Nov 2026
 16:31:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-7-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-7-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 12 Nov 2026 00:30:49 +0000
X-Gm-Features: AclHuK8yVOU0rM_Krxb68wuVhwe9clhKmxqaCwvxpYiiXo0gID9uClDW_ZDomNY
Message-ID: <CAJuCfpHReBDoXj_U3Dy2hksj63KyHNBm4gS+wtR_ywidyJ8mfw@mail.gmail.com>
Subject: Re: [PATCH v4 6/9] mm/vmalloc: only flush the cache after the vmap succeeded
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6F43C0005
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: z1xf7rg8pahmw91yg5h8fd8mfo4p5djw
X-HE-Tag: 1794443462-518349
X-HE-Meta: U2FsdGVkX1/sYzS06kzswzLO3oCD6QjiTFeQY7wBTCpofz5JZihpfoI22iWFLabkJgO7xdohJtKfKgqoGMin+K3I3pab/QNa5BrYyhWBSmAB2gxbxPyq2uI9I2Xho2Hhn9m0RGEq4dcZEJ/sworypr+WMenIWyqi3XI1LPtuENib447FmWy0dT/JpROtVX3imfF8voSu1x1p1DbSYB0lbC6MfCgiADBb6Jo5cNGDvP9GDvtG/wkvyUnVQHn3UgEyAVgAPnWXyK0TFRRAgcPq4HEFfwNgSEwW3E7HNSRaQaYTxq9cH5doWH5NT5z3wNycbtHX+Naf0Z348+oM/o778LM+jzfdl1wZpd/gkwBXORMeoOMwe0m6lZDpevER6rPT5tAExe6CTCa9GheuV/uveyxgSsXMu3az25AlD3zYeCFf+wyz/tLt3b79/Uaf7Iq92UBypIWupcnC8QvsG54Iz8ajJozE8cHNvn37o/KGNo9m4ntiOnaXI114pgA5VZB3KiiND/B/X18cxiaHbHsLGyvlqpmqb03LdvNn3clGGWXfgXvBVpagOmU+3Qc/o64k3Jc7jLaEfJqUOlosTjYIDK5h7Yb3uwPT0cGDXFzxsaNvCKkylrjDL5tefJiN+5bk3fMSXm7R9cCOcc6yTBhvEtrK9wDCzdBSZEWtOQJnQpn1vcmmaqMfkoZhINkrQa6TO54FiyS/JvWpuKj0dfPXrgQdI0QT21xjj1iKQCCsax3/EAoD65swP/5nG2kksu3lSOEDCYVT9JPFmckCyUXtjkyk7MiPkBLRjuztWH6/8J1kado/3yFDd/IbvWn8tMIfdUBopMkZuHmD/DrItCMxSLpU/6TVsoGjqVUyx4bu6XUttCZUJhl5+ru/7w+mqblRuRlolfYB6/ku6R2WFBhpdJqsB9hT7SwcU18XbvQYQA0594tBHczk2PG7XifuQnsSz/UOvWvum/9RuYRPg4u
 EX1fABy6
 B+hOqXZbFPsX0B2gBKnR6fuHMCVby0qKRuCraLyE1kPR+pn+/zaRvyE8Qith4uHA1rfyqCDV/fOWRmOHF87v5IuGW2QvUZZj30H4EsGm949Dc4mMdwKhDd7DItE0E38juBRLToXew4+C0pY/M0qxMXXdR6koJUjrpuFLP6//uFD3qqrdC+3GE5q4AcM6YTxAeFRUOWLanQJVlG2ieKydPTQmBNq0F4KONxzhHoudVJlrgonzYltwK/6O8AwERuzhzhHuvHDLKh4c4DeORobyjzBlV9KED0cz0zS0+ePZfTtFYpdf5Nvp9Nw44xcl3xW3mWswIcz4MVjKCTnD1ZCqvy68DLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> vmap_page_range() and __vmap_pages_range() call flush_cache_vmap()

New vmap_pages_range_batched() function has the same issue, so needs fixing=
 too.

> before they even look at the error code. A failed mapping is never
> used, so the flush is pointless at best.
>
> According to the Sashiko review it is worse than pointless on UML:
> flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
> PTEs into the host OS. Flushing a half-installed mapping therefore
> leaves host mappings behind for a range that was just freed again.
>
> Only flush when the mapping, and for vmap_page_range() also the KMSAN
> metadata, is fully set up.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0565cbfe325c..3f98056f8c7e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -369,10 +369,12 @@ int vmap_page_range(unsigned long addr, unsigned lo=
ng end,
>
>         err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>                                  ioremap_max_page_shift);
> -       flush_cache_vmap(addr, end);
>         if (!err)
>                 err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
>                                                ioremap_max_page_shift);
> +       if (!err)
> +               flush_cache_vmap(addr, end);
> +
>         return err;
>  }
>
> @@ -758,7 +760,9 @@ static int __vmap_pages_range(unsigned long addr, uns=
igned long end,
>         int err;
>
>         err =3D vmap_pages_range_noflush(addr, end, prot, pages, page_shi=
ft, gfp_mask);
> -       flush_cache_vmap(addr, end);
> +       if (!err)
> +               flush_cache_vmap(addr, end);
> +
>         return err;
>  }
>
> --
> 2.25.1
>

