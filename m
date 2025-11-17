Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6490CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332BA8E0014; Mon, 17 Nov 2025 12:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3A18E0002; Mon, 17 Nov 2025 12:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D22C8E0014; Mon, 17 Nov 2025 12:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 062688E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:23:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A887C12C99A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:23:50 +0000 (UTC)
X-FDA: 84120771420.18.D7AC484
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7A90B4000F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:23:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tkw0ZM0f;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qp5KUxLhGISuE+Ff+lSnz1d0JRobpfWkUeOiVC2lEbs=;
	b=03f33sqeBAEVgll51PGGueuPn0IUNaHZNDLPrf4aAkRmd4nx6fQhlNzwmGiYzHjqcNNnlQ
	lwbgKSiO/gN0KY2huwNXMY7/kT6MZWIjSnpFGyoC7Rkn8fhgQ933gmWGdisnrxur8M37qJ
	Hg0jzs1+DJE7U3PhBKuZV7F/OuG74N8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tkw0ZM0f;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763400228; a=rsa-sha256;
	cv=none;
	b=gFl0M9PF6HF+6SHAd8yv8r2sxw6yPNrBmPICle0Bshp/xSo7qIELSKxaUAjs8Knz81fyVw
	kyBAVn08icFOud+PRWLP02MQr8bxV/WjXlH5uYl2W6wjwxYjjAt6QsXr7PXzcazuK+wgHV
	WP2TwDB93XxibXbrKnPw8WRd0hQLXnA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763400227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qp5KUxLhGISuE+Ff+lSnz1d0JRobpfWkUeOiVC2lEbs=;
	b=Tkw0ZM0fRORMtrSJqYXyBk9Z5bv5rJQWoIg7GaRbSdzPjjeLCsUZXYVSbUua3+wexjDOTn
	NHZyPfDkkwx/lzXFrrUyJmdlUitYnjBpV/wnD3C5yFM6Hhu+5qBbTnfxBLwgeUVAu1DyOk
	yWJ/SNydognZswJZ+Yyhr2YysWxRjSo=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-HLMuF0eSM4ilSk1L3uC9IA-1; Mon, 17 Nov 2025 12:23:45 -0500
X-MC-Unique: HLMuF0eSM4ilSk1L3uC9IA-1
X-Mimecast-MFC-AGG-ID: HLMuF0eSM4ilSk1L3uC9IA_1763400224
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-640ca05c6e0so6883782d50.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:23:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763400224; x=1764005024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qp5KUxLhGISuE+Ff+lSnz1d0JRobpfWkUeOiVC2lEbs=;
        b=cKmX9bQ5uZ+sixonY/XS9A1WRtpCGukslJkyNR4bGn+dcu4nSsZh+GOpssYujRFkt8
         y9rNhPiDlTsVpE94TxFcYI4pGl+f4eeWnPaejO8RUCWm4Gw8IFYMV04ciclHCaj6A0Hj
         Lk5KQXLS6lOVM5cyQm96+hOkLFPmYE6Q87aZ0Js4XUOlGkMCL9Um0mlpN7Q2MC2oI6zq
         NAf5lJnDJJjFVXyd0C0VKlYdcEev/MyJZtOdYMZanmTafkDcELWpU4yp4IgNkt3q9+kq
         atCyn60ipfCVt22fWs6ULctH8eH2iFWcY4deMgu0cnVLfHQPGI3TPK7H+VYL130asbHC
         PuBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUvm4un2bpENd/Ex+N6QQ+N/JwmAl71DsRwpTowjcpgeOmAvhr7M6sTt9gWkuXfaFVLgEg9i0P3A==@kvack.org
X-Gm-Message-State: AOJu0YzkhkLCnko09PjDCGGNUv5kabV6D1kkqQLGiw6H2xQKQRiD0VvG
	yWScTv/Ig4R0bgmX3GT0AXFFgbdJzm5FQoyUz2cdDesbIKySLW8mqp/RDhJxumE0OL5o3HL2N3C
	Gijhm8YDm7LBmD9DhZajcFgGaYamxp99kESvVb3gjuyG1oEAq4YEurtdS2N+Ld+t7G6uIWn2Xqx
	eAU6hY6nDLhUGBMd6HJwtSTtaPki0=
X-Gm-Gg: ASbGncvPAghyrbP2m+n9az0DpVGkbpv8mUSPgEYi6hNcCKDKm9Zc6dSfYjLwf9/YIsR
	ZDJEVYPVstx7/MmFHaxyHTQqiySq7JmXC5XP8ipazSo0qh+MXtB1HUlTdN28MlUjEqUbt8UUuKy
	PJJ8zZzDm68Ga3UYFTz9cvGT48OS0DN/x9q32qIgMPe5fw2nxDFypCcPSlvjUBFHSdV1ijmA==
X-Received: by 2002:a05:690e:d4e:b0:63f:c4f4:e199 with SMTP id 956f58d0204a3-641e74d095bmr13612484d50.15.1763400224251;
        Mon, 17 Nov 2025 09:23:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEWsjx7AHVnB3dlxZdIm1IIZE1VYXb8pXdfHH0Z8kPo2BUZS4Hm9pVpmSeacTcZbEEKgFuLbrIoVCEKyhrBjbI=
X-Received: by 2002:a05:690e:d4e:b0:63f:c4f4:e199 with SMTP id
 956f58d0204a3-641e74d095bmr13612437d50.15.1763400223753; Mon, 17 Nov 2025
 09:23:43 -0800 (PST)
MIME-Version: 1.0
References: <20251114030028.7035-1-richard.weiyang@gmail.com> <20251114030028.7035-2-richard.weiyang@gmail.com>
In-Reply-To: <20251114030028.7035-2-richard.weiyang@gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 17 Nov 2025 10:23:17 -0700
X-Gm-Features: AWmQ_bl96nNGbgMBLsj2zP_O2e5v9yBmPJJcnlXBIvi-6csDRolqGtrMzIswGs8
Message-ID: <CAA1CXcAbz2smWmVGjZ93jg2HWNN-wchQynfkDr-5TGCxEDZq4A@mail.gmail.com>
Subject: Re: [Patch v2 1/3] mm/khugepaged: remove redundant clearing of struct collapse_control
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YyKUJwZ1lQfbU48obPc3ONcl9HRLages365zMEsdFG8_1763400224
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7A90B4000F
X-Stat-Signature: a1x1gb4qykaknewdi8h339ptgfuxz3eu
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763400228-799132
X-HE-Meta: U2FsdGVkX199vuEYX7HbAheLUZKYSuJvbIgJCXuW4v4PdZlRdU6WFshy/XM1SVE0EEVw07b4jCFK8T+HkGd/gzKH8t5hDbGhXZCF+6WUGnPzM/ak1Reaf2OZOifzfe83dSNTcEVXW/5CJ4GRshi7fGRAMniQAuwqgkiXf5PnaaVJuZzuFDsNc7zxjud1v1TsXoh1vb/IBBX1osvRWdc4pSWGWncOoHefu2CUXoidByxYqm9XqS8NEEvXR3uaXB1ajKElsFQpHPyxgzZ5qh9q0GPmyWdq20pF3ypSvu3nZBSGRwR6Am0s5BDs73w+Bu+3T2/cltqb6+WqujmUrfmDHbrYWFvP40SjNj9a7DQKYbiwt6yGuSNECEQ8Ng45apVSKGFnJCfuySgWJmBVeSPnOS7GQ/gGIiPK4L+4AnmQKsbVpXS9Euz36HAAqf4PPg6mR0iiSRqlGrL5zhZ0555QPxuAj73GdU6eqIgCZ0XW+FzMRLCujH88OekTL3N5+zi+f1l66jslCHdjaaXs6rx0lT9+bS7v7zPRIYNPRD/xie9RyKHVQytMJFDAoc3nMUS9aZhHM6B4V31V7SVpRnzqskJh012NYG55+OkN0Npwfr5RQeVA1EqkpR5SVl3nDGFqwtFGBUDyNX+SieUeVoxPsJpJOh5vIXnt4SsksRaZXAMBkcui+D5Xyt4ZYMbBzBooL2xctgVRS5IXEA83GVdUTfX3lJU152q3uwKS3NvpsaKQjt+eIHcpZOtmHNHMX+6fVCLWIUr6Bob8+CiI49ZN5jTv5xEq9+HNAP6uaJwdiC0jJWia+k6WNjAL2IURPqVry0MxkhjUr89yiUBiejtJ7P/sKa2qWC+7t5Z9bqoVnxrrhIXWCbKdCYjikFeFiC4NKkn8emLe8YVWHjRU1aFscUQJJB2VuNU8OLT09lp7wMGinHXg1nleFd0ITKRXi+7j12Id5H55b7HUrpxdSWC
 Snz9dwmZ
 9izsF0C/viRaGQ1TkuJUUv48sm9JzXWn7bl5ZTko0yVz1OSV/FlSv6eVSMlwZ/5ayoNiDukxA7gcY6cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 8:01=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> The structure struct collapse_control is being unnecessarily cleared
> twice during the huge page collapse process.
>
> Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
> perform a clear operation on this structure.
>
> Remove the redundant clear operation.

Nice! The more we can simplify/unify madvise_collapse/collapse the better :=
)

LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>

>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  mm/khugepaged.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7e8cb181d5bd..1fc8986a28b3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2803,8 +2803,6 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>                         hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
>                 }
>                 mmap_assert_locked(mm);
> -               memset(cc->node_load, 0, sizeof(cc->node_load));
> -               nodes_clear(cc->alloc_nmask);
>                 if (!vma_is_anonymous(vma)) {
>                         struct file *file =3D get_file(vma->vm_file);
>                         pgoff_t pgoff =3D linear_page_index(vma, addr);
> --
> 2.34.1
>


