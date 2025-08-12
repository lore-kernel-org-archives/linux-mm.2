Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D4FC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 04:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B980A8E00C2; Tue, 12 Aug 2025 00:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FC18E00BE; Tue, 12 Aug 2025 00:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADEC8E00C2; Tue, 12 Aug 2025 00:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA5B8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:47:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C7FC1401AF
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:47:58 +0000 (UTC)
X-FDA: 83766873036.27.0BD7695
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A9A5140007
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:47:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAjUgLl7;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754974076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SB5XV2LLtmQC6ufwp1mnBrTeEc9IkYMUbPyADdPmVGg=;
	b=f+Qz6Vs8/WM9QZ5Ax2nNP+e76S2AnNEfJJT2Qlxh8L1XYSoSYAN2MqQQQygrBq4SD3OJa1
	Bn+pYXpzcYPcLHjfQHk+R+Oqn5cf1wT3Qch21YRduIwBpzLu9HE1gGw8oZogb1kyN+XYTS
	dgRh8jJuc7zvRZf+7Bqqv3dQKQ51/6M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAjUgLl7;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754974076; a=rsa-sha256;
	cv=none;
	b=6anyW51IVFjblZWHNqGLWHDdGdzWqm4w5P+3zBoQCZVAwjXGpCgadOW8lcgMy0DfVWhj2m
	ehHEvWyZhFp/8NglPxxEcF2swR9XZEbme3iN84HnkgkakFu4VO2YObizxZCPXORTR4mzJs
	x+Z75w2EktXg/oXDtvJj2IMfbspQxd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C47F744430
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEBEC4CEFA
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754974074;
	bh=e71VLinW5AHv7lSC1tatFxzPb+7mAbNIGLPHcCoOSRs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WAjUgLl77l6UVu9qna6Od4sYchXOqUtAYBcuYWQwiwbXKo3DhfUpRb92kQEqiYcuD
	 YY4OrO6ZeBliqXBZEJG6+RHiSnfpjCMZud9nBxDPXHQZcImNV2N/DldksKt7t8FJIK
	 kUIOsg58WWqAT1ZowGbQGO6iMqgAmf46gCkrOQ67nt15zFqOMQfQCmWGR+Jcqi3kRm
	 NbP+x8Bj9/oDFLn5z1x3taOLny6FcDNPGSwsv7BsB10lF+h0Hn2eae1NvwoCQn+NHA
	 o4D4LKEndN1trhAfpvnO0u/wheFfc0t8c8/DoRajMXyCgVnmqy0zcXd7MTSzk3rLJi
	 DlJOV0PqjR7fg==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-459fc675d11so26865e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:47:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWiArpsqiL2xi3xEe/N+/xTDOv+nAPr4svZ2E3ehVYsnSUBcslDK4SJ+eIUUC9UJWOds69oJK8f9g==@kvack.org
X-Gm-Message-State: AOJu0Yytf0PJdykLa49kjreR7PMRY6iuvWczaxykl9un3O23puDl6lO+
	dzyDydhAJ6dtbZ6EWroBGUaUhyv5iTBD66GYhgm8T4sqa+Q48mSLh+DU+AbXR0O5j07vvNcfRr+
	oFIz/4L7pwgTFjdiI5GIMElEba5SSdlnTIOKMqx7Q
X-Google-Smtp-Source: AGHT+IEAg5lSfpnioeUcNmQFoqWcyMdIUA/hvVXeGeh9JlSvvvtwinlKM5J0m7oJtm0oDSjJvQjzzxVT0Ys7wchxjIQ=
X-Received: by 2002:a05:600d:c:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-45a11111c89mr975835e9.2.1754974072980; Mon, 11 Aug 2025
 21:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250808-swap-scan-list-v2-1-d50e4758ecee@kernel.org>
 <CAMgjq7DnniGUdpQQA0YF+LuMuL9+FCLQJP2Q04G_Hsd1sztv9A@mail.gmail.com> <20250811212423.5667183e69c373c1daf95ecc@linux-foundation.org>
In-Reply-To: <20250811212423.5667183e69c373c1daf95ecc@linux-foundation.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 11 Aug 2025 21:47:41 -0700
X-Gmail-Original-Message-ID: <CAF8kJuP=WfkPSSNs-7RS=1D+3LkKrMU=84o9mhOb6wTPSRNUqQ@mail.gmail.com>
X-Gm-Features: Ac12FXz-iPlIRTVDzJuGwI4wMh3CWqgXJdkWTIuII9-oAMu2X-IrrPPRX7qtJD4
Message-ID: <CAF8kJuP=WfkPSSNs-7RS=1D+3LkKrMU=84o9mhOb6wTPSRNUqQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapfile.c: introduce function alloc_swap_scan_list()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A9A5140007
X-Rspamd-Server: rspam06
X-Stat-Signature: ea6r7umbis91z53knscdqas8fqdwtssh
X-HE-Tag: 1754974076-95585
X-HE-Meta: U2FsdGVkX1/3/VUPVwGBYpcCiuDz/69LqzdYaUzcNiTq22uhNs1xxbZHxFYx5cnLPmHyka3VEE1nD4/lGSn6OrG50hAalafweBfmR+p9ccQpHk7dnMmhz4ZdwmEX9YtBW+/n1BcOLMrGJcCiIfeEWdhD5fWEuVTRDAXnExjiBJUbxQrdO9CzT055NYQOWEltNkdRXNqKDJ7f3VLiN97OMgvEplfbQiGegMINvnB8xU9aZtPGKZxhKzqJ5Pi/SvYTq0GNnf5RZbU4yBFdE7myBF5ecz0Mba7fMlUMp+PpfhHdMZrsy6pL/xIp/nJGW2yVi1OFhBzOAZ2y9HMoQ5CLgV79u6+veGp3EbCNMzD9/CW2e2bk1Z+Pv6R4WEg6KDUqX/rY6K9lBh2mUncfrJkcMiLfR0P8XP4YBydO1TqOPyiswg8wpE6UNV29+i+KAior0VBL0n24DUpyk1Apt4UJXxBmTrqEZ7uPQIYYHsD0h99pqEUjRHTLxJWfVSXOZh+VNKMynX6AEpLg93O74oacL/k19gOPs9jLxd582CkIb4LGL7vGFT0iAYlJBQPTAqhwIJcURpxMNVYy3IPej6f9Bks/ER+qMnrfeBDbndm/eoW8wuv+cIK+0S1anA/QMmRyV1a1f6tl4dF2HkbV4M3/wVuN5ogOrhJU+uwUtnIjs/Iek4UOCiD3yn5zfia+BsFnpvxvbtvm4SNJCc/qMLbE0FLRAF+hqGPyK4Dn8GIFy3yFiRjc66SBN9cTXpqs7Nj7i4h8/+dEZVxCYs/4/KJ8mgiIu6JrRWiqtsQXwYeiGeH8j9Rx5G+WPQTPfo4N9VQ40ChByub8/k13pBDc6X9zksYtUTUGS3RKFlYsbQD3wzyi8YoUEo0PElNZkNvcNi+dRtNe4LxG2FSzT+w/pU7amVpxSYFIy7C0aUJY+6KDNv81uNhc5DIQSgeN/V4DDc9BSqTuw8cI+u5WpO81Ixu
 cM/Tfbay
 pkrmfpZh3jl1vvVhZ/4FbuPMXEtB5+VDYsaYtOtu1FqSa9+/n8eFnw0P6TyJeZMA8gDYJ1mj4rI3MeC+qWf6O6lHRVIG3sNPi+3oKA1fGlF6oSdHlASYt5yFmIne8z/beksm/wABraKdsbB8oiMUhWSurNc0EQgZlQ066GeoWCSM5kDWTBUeGH311i+MYZOxl3P/6lCNGlg1zpGA5besMRazlVw7+DguN3zLQlCyz6N0aLTKFNJjQq3uRq2Iag0BCv1um1K7T9J3Dp4MZ91pcEGt257FczU6lcP3ftLmpg4xPT0sbn9i3kG0+LY7rqEEr76S65Squ4dfrxq1JLohXNyRMYoFkCfF1q16XGNGW46t3l3ICSbNCPAF3VHVmc/JgjU4QpvIsG4npLJHZPZVFP5YsUKU/EkPoJaNgOH02LfIf79/chWdMsv/fYcUJ4ehtV4u5G18o0S2MY1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 9:24=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 9 Aug 2025 03:51:48 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > On Fri, Aug 8, 2025 at 3:48=E2=80=AFPM Chris Li <chrisl@kernel.org> wro=
te:
> > >
> > > This the alloc_swap_scan_list() will scan the whole list or the first
> > > cluster.
> >
> > Hi Chris,
> >
> > This sentence reads strange to me, but English is not my native
> > language so I'm not very sure about it.

Ack. My bad.

>
> Yes, I rewrote this to
>
>
> : alloc_swap_scan_list() will scan the whole list or the first cluster.
> :
> : This reduces the repeat patterns of isolating a cluster then scanning t=
hat
> : cluster.  As a result, cluster_alloc_swap_entry() is shorter and
> : shallower.
> :
> : No functional change.
>
> Which is hopefully accurate.
>
>
> LLMs do an awesome job of doing this, although one should carefully
> review the output.  Here's gemini.google.com:
>
> : alloc_swap_scan_list() now scans either the entire list or just the
> : first cluster.  This change eliminates the repetitive pattern of
> : isolating and then scanning a cluster.  As a result, the function
> : cluster_alloc_swap_entry() is now shorter and less complex.  There are
> : no functional changes to the code's behavior.
>
Thanks I will do a V3 and use something like that. I spot some other
minor cleanup required. Might just add it to the clean up series.

Chris

