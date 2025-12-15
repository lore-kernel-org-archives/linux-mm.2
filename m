Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAE9FD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8AFB6B0006; Sun, 14 Dec 2025 23:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C246B0007; Sun, 14 Dec 2025 23:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951C56B0008; Sun, 14 Dec 2025 23:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83FBC6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:52:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28E261A0DA3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:52:06 +0000 (UTC)
X-FDA: 84220483452.16.2D90D69
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71EC04000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:52:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwUww0ly;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765774324; a=rsa-sha256;
	cv=none;
	b=iOG+Xz8X2TRNlE36aygMUu+/nQXZD73ADq/uHcYoUSiSTa8DJ+NwrYVhBwbNoMgq5bo/7l
	fR6KURLaVkPtl+zncv5MpPDweeLW1wcvDiamCGMuN56v18fPsy+7iqjkBQAhZgu0e+mMcK
	vjo4AoxzKP4NhCEOz9RQiQwcs+qKbSA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwUww0ly;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765774324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJZWEW3rjpyPm3kqWqcZVNIVlSkHtvxpYx0bAzrLBeY=;
	b=ulOZnXEp4LvmeCCXwKAuXzOmhDp9a0b+tJKVEGSxt7PlAfeK4U07pSjgOskiH7cyK0gIRO
	AWNpMveRbiVdlz3sPK0NgysYPMjLKdKF1KTvy1+tLBWJ3KS/f9YetrsEhaQY8tumsb9ulF
	Iy92waiNFIYLFmRVV4i0bxRUPfzsEfA=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-786a822e73aso27479297b3.3
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765774323; x=1766379123; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJZWEW3rjpyPm3kqWqcZVNIVlSkHtvxpYx0bAzrLBeY=;
        b=XwUww0lyxUWUnQWHnC26Xg4kTWAc8OpW3KE78AiCz4wmWwcKuzWylgMQIRuPO1o9+H
         fVD1hepdYgaz0FMBIk74I38ZAK+Pi0m6gYMSMl+uHZn+LnELgVzzNgzhmhb7wqDpZEw5
         eKL24FdRfHbe+z0DuhCOp+dCkmlyBaFqdnD3uaYWjwCQIarWkwOt4sIG1Ra2YdxTn+b9
         VX7nDA7XeKTBaBC9FQGnHeIVi2HAR1F3zZVpxgq+g3FjQDRp2ye93xLTnisym3MnEabJ
         qeVDbZPe7bYGNPzllRlx1UCe6NYQfkexbaS0v6raRT2C4BvykyioAKh5md2MQAsgh8OH
         N7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765774323; x=1766379123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JJZWEW3rjpyPm3kqWqcZVNIVlSkHtvxpYx0bAzrLBeY=;
        b=Gn3klPl4Ur185LDh2pu7nEDifY1aMmi1fpqX9Qnu4eIBQfBQp8tq7Gy3ycW5iEZfsx
         QvvKN2jrcHRkgcCVeiMOSuF/4xBYWG0q/6biLncFieYy+qGpwFdN79rtSXs6svYiKnI+
         G8bu7z92cOOmDA+266/U9QwxbmdsZXrW5O2YaILEqvS8jEaNV7HfRQodycWN0Nu0lsBX
         XqYrZry1ryiIJerUxZUJU/+HhasHGS79p7uQu1NhcWlHxWy/hDybufJPnFAZysmbZzLs
         k0eUpZVOPO5gkXV5xi2t6iouoS3I3bTlbORVib/Gg75zrgjjMrj/trChPxuAT8yzRH6J
         jAKg==
X-Forwarded-Encrypted: i=1; AJvYcCUAfQati/iZG0l1Sn8dN9mV7QOPD2sFc+bjZalgQ4BsNZbaDobOnBoYQ0t0D98StcTjefRY6aswfQ==@kvack.org
X-Gm-Message-State: AOJu0Yww2NZ5FZtxNoAMePCaLhEPaCmrlWVpVrfBx1d3xlpkKOc+FZwt
	XSq7+RcwPHVM3kEY07eI0R+/svcNeuLVO1BHdfrdTIER8uWa5NxrKBeeqShfR2vA7mShxPPE7Of
	YouwpezbXx0PFp+uYPIYsCyMBp/mJ+h4=
X-Gm-Gg: AY/fxX7Bx1eyIkEORk/KvEcWuqtPAXT00/I2nqJmsV6LOW4E92vZ3tmkutD7hy6K+L6
	0Bw87OW33Wt3PfjlTOJuIETmaOPyP5mqSW76rSkX9yR7/GxMHs3VzceMl/3O4pcFShqWH6lsKb/
	3/CEtMLeXHPMo9ukr2hK/yQ0Tem3D+AhBopehEkC2Gzl+pJ8dVHDzpcv0fn7uvNZGg8a5TpRQe7
	7Naz3rCN7zqIyrHfQpINi37LYR6HfH9HSzOb8Su3VwXmbCpIcBnbz82n4ee/UaLn3AsTVQ8W9Yk
	Ouf+h9IGJnVJjeqlT19oehv8fIYw8viMzsyRTZFoB7cqvUBygMfuss6hTBAp
X-Google-Smtp-Source: AGHT+IFa+Xq4xdXr+GjmqGO+iLSXAhcftpAh2di2divRGWmispuDV7Ia70Abn6DemtThOp2mj5eAj9FNMUZcDTCcWYk=
X-Received: by 2002:a05:690c:dd6:b0:789:53ab:931f with SMTP id
 00721157ae682-78e66d7d8fcmr87488747b3.16.1765774323330; Sun, 14 Dec 2025
 20:52:03 -0800 (PST)
MIME-Version: 1.0
References: <20251213083639.364539-1-kartikey406@gmail.com> <20251215041200.GB905277@cmpxchg.org>
In-Reply-To: <20251215041200.GB905277@cmpxchg.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 15 Dec 2025 10:21:51 +0530
X-Gm-Features: AQt7F2ri8EReXAsAIp3dK-aCmI33yx_-bXtMPpzgtmCMCcba10Rx_0iVj0DDMvs
Message-ID: <CADhLXY6tueNOZKqjWEKU697_pTGuLyiTdm48CHRH=W6udmQVZg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: always allow writeback during memcg reclaim
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, mhocko@kernel.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, yuzhao@google.com, heftig@archlinux.org, 
	oleksandr@natalenko.name, bgeffon@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+90fcab4d88cffed6d0d8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 71EC04000A
X-Rspamd-Server: rspam04
X-Stat-Signature: yjdq7rp3zxgfzgfakddr5nkca48y6dd9
X-HE-Tag: 1765774324-538734
X-HE-Meta: U2FsdGVkX18uLNTEFrJW6IPTG8rHa/Rg1GBAVvS6OTLMOeOKk9DlkTck4b6fp8nAy/GfgZ8kO4OowUYQEwW8yc62v04PdBA2rUB+rCFZ0ZcMoSrFePXSz2XMb4DWUNypS2AtbUbjno5ci/fq/gS1RdTLrT68BTxnTfr2E7eJQ2GsLMpG30WrsdPnsh2A56lzX5XhGLsRptiI1BtE0bi1pX8A7d3/vjrtHmdN22kOax2zcRhHlpauGwbYNAc/kY3mFxoRC0sab8XG60HJCiwVZMLZDSOM9tchGSKNGQ5OiA3kD7u3Nh4W1jSuzEQ8C4p9nI0FYyB0YQ7YlXbjeETgu+0VZ1iqG9TEK6HYEODfPkDBumbHG2LnlNgR85fYBWOrrkQr70Fzj5dC5JQYwLx3uBKB5wIt20eUpdLPPArDeglrs4g1TIJciNol4WsF3+zQfmfBC+Rm9Gp88wLbY0DktGYUozx5fvpe54syTnwdMWdQGh2ZdpToe8JRNkSdpj9g0nE/Gw6TZNBdLz6iZnR/FtBnUNL4V0Sfs3cwe6yfZjDEvR1Nax7HONVj0sZi5hx+8nCn2ctSx6kQbhZJv/OI7eTVzJL2n9vYC7afooxnsGdV4myEQZm+QO9R//Bkz3GDt/JJpW/i6gEKFCLo+OigAF1HKgAsUZtCO8P8iejTg/44LVq3CgHJ0NGUzQb8gqT0dyHLFXGZIx5Vh9SUjqyRKSMLQAcCJfeRoDC+HFid+vhp+uLZYMofFAlZ2OgAei4WcnxpTkg/Xhyrj2m9gymQ7ZllxaTVsN+YjQgp0fD8xozPsGT3/HigYYoBZPoYBfVQ+e3qEbP0AcoePvJaUkw0OsiU7kGRO1WEcAb9ZK1YIW/nHIGVKcaTQLosjKnHClOLR0m0uS81sASoUyKqgCtndKdWgC6H6qgKniq/VasPkTSnZn3AoWNk5yEyJjhrGQ0iSnXMa+4AorV6LtQx+OU
 ZrKMEGiQ
 DpV7NnhYt1OXd4o2MuQW1EPqpXDeugiOThwqb4m9eH8qVp0WZIat+uFA4LjxMzUti12KwX9Mdz8mcLw2GMrFiG9Hzc3zHw/IIMMwfU+lco2oTIolAjWSb4A4weA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 9:42=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:

> > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
>
> That seems unrelated?

Sorry for the wrong fixes. Correct  Fixes: ee814fe23daf ("mm: vmscan:
clean up struct scan_control")

I'll wait for input from someone with MGLRU context on the broader discussi=
on.

Thanks
Deepanshu

