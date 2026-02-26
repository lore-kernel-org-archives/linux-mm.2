Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08203FD9E0A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431B36B0148; Thu, 26 Feb 2026 14:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409936B018B; Thu, 26 Feb 2026 14:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FCD6B018C; Thu, 26 Feb 2026 14:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 201F16B0148
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:57:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1CDDC074B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:57:31 +0000 (UTC)
X-FDA: 84487667502.21.488FA79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CCA2810000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:57:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0l4sx+p;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772135849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD34O6+tCfVLfAuTIWen2G50WZkNfV1Tpx2VC9ZUXK4=;
	b=P6i01FxANpmJBrV1Kb62/7YemrxnRqLuqH9ralb/vZsaQNsu8/enVOuZ9PtnpUYQQYFx0f
	6JvGEWztSkKFby607BGPcc/xLDRVZQL17YL8Q1K0FUJ4bKs9wVzPAqaWKEgnz67zPsPVzG
	tU/o070fsYjGe+ipSgyFTBFp8FQZ89c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t0l4sx+p;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772135849; a=rsa-sha256;
	cv=none;
	b=SRKIA9edzEQRG8Y+t5Tjh9xz454B7sbTVy4JdhXZsu1EhHY548Iq/n5NyaI1BPpJV+2DrM
	MsfE6MspQqt+3jC5fsQnHzZTh75ENt2qwvAhRYJyP8j9awYdHDQGt29/BxnWhD7iGgW2GL
	TENiVi/us8ZExIvTzSuyGQ5xnPhb3Cc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 287F860054
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28A2C19425
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772135848;
	bh=UD34O6+tCfVLfAuTIWen2G50WZkNfV1Tpx2VC9ZUXK4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t0l4sx+pnjuj2urO6rGXuZStjHlCvNGLa2H9PQLLpY8glywiPFrJB2t6imEL7yEM4
	 7/OW1Y4ggZYV/l0JcCVfNf51rBija1+UMAoHrOXf0Gv3uXVyD9l4MOfkJT1WoEsYCR
	 4W5Ww4SppGUSAn0HgLOHn7omeDdcyHY0aBYdbeGAvyxx7L4IxjgzyxNXD6/J3L2H1R
	 6ebLZziuuKyLMnGSRQyr1V7o+pS8ZpdQ7lIQpbXyBNLbAEZkHqQUy56/XjFUkksz25
	 p1/192sEAyyI9Rv0Xp4Ry3h3CwKLPHUD5goe4aR/RJbD78+yu9gXLHrXmplCOb4aeN
	 F24p8fWEaA9/A==
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79863ab8478so13071217b3.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:57:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVljU06uT+27wRz0/D55YQ8w8/5qFHewkZUaU6yEFmjisLZCK54kMpZ5e5koSi9tWec5ea4/deprA==@kvack.org
X-Gm-Message-State: AOJu0Yz+Ik5HuU+5rucZQ0cLZYJqtvmOlZhklae+QfMlgExh4PR8tqCp
	L1ypr7jjYA2WW6e+x6ks2yWHQJh1p5lrqvIr98i1bKVMDkJHu/3F6pvfrDD0/QMSjCsEUuKxyoY
	bBv5bt1L8CeayT20hCHft9nj6LBkP6L3iVXlZjZJi8w==
X-Received: by 2002:a05:690c:1a:b0:798:6042:12d6 with SMTP id
 00721157ae682-7988561037fmr4493367b3.60.1772135848157; Thu, 26 Feb 2026
 11:57:28 -0800 (PST)
MIME-Version: 1.0
References: <20260226010739.3773838-1-youngjun.park@lge.com>
In-Reply-To: <20260226010739.3773838-1-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 26 Feb 2026 11:57:16 -0800
X-Gmail-Original-Message-ID: <CACePvbWKg7dT=sP0fqs+So8BnE3BKHgLRaaL9Rqgj9JJ1mp-Uw@mail.gmail.com>
X-Gm-Features: AaiRm50MeOyea2-Fgki-KvZuznNpIXRYPJXIU5ywr2Vmh7qwLR4K8lrUYx64hUA
Message-ID: <CACePvbWKg7dT=sP0fqs+So8BnE3BKHgLRaaL9Rqgj9JJ1mp-Uw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add myself as reviewer for SWAP
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 61rnzp3yupbm8wrddd5fo9graxghxgj9
X-Rspam-User: 
X-Rspamd-Queue-Id: CCA2810000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1772135849-54756
X-HE-Meta: U2FsdGVkX18C5Im2nfTJ1A+cGGoBlnN3cJemouGXbyssHdY9rpSTelpvyvf33rZVa8RBr2RN8y4u5T3DeG6mD7NOAODeic0NW1wDsc2YG444HjZ3e1V54JvbkC1Zh+o05ktneIyJAPecYyOtuHBU87/bm4nxOseBOIGugDgY0pGKQGnnNVnTZSR+RO0OlO9hlo59AI5cBMM2qy5w8i8mf6ujLYAqdcBSKSGF12dHvxUKgs1bcij9Dp4IL1PGQtjGHVs4n/s84FkPkwpp1VdbrlPmaNYjbB0Azpxlr3PrxLqY05Ipfyldfc7n8+KfroX2FkTtmhj7OGu0OUg2vMI2N8CcTCTLfI0pRlQPAKyzjslm3/cTIrj8FdFu94mKfcm5OEUpDWlbm7w4Hyds4K6ldNCa6p1x/d1QKNeRo5tw+7g9bZ3SN5kp9/2xPAdgiWkZ93bQpqyb3W75UEHrXmGS280OG0Wo19qomoSLnSqF1+TJzZvUa0QedY/rrtts90uf12ZcjUbt2NMjGkGoAoEMKGJ7qlKvl0RvAWZULs5Abc31txQsyprETbGts1SeYOK5Ebe/mXufWLSQrbSfA6EZIowINflqOOuPsaB5NDQ1ze/wB8ggFPAhBJY/ggEK4xeqCmLSLHC6Q5UaJvoWsYFQlgZSO97CPIdW/4IPOnmCdcEIdMdsCF0P9yuxsiov7gAUop0m4Lwch+/HZqpJ1FG6XEBwmPtyWV82ua1bAcNHb45fombYLMPaTEP/7qLScumJT28VMGmna1ZCEtrqZcLsoojjsIp6EVBQ/woxcNdgaw+42FnoiO8Z74X7byZpunvqmKSO41XBwv4Y905TzqnNd3t11mtxWqp6a+O+dYCg1m+syFZV71GcPcl+JXLQG+tXbtiNkXhV04BmXQFk6vf2G5K/g8vzO19iLkXZM0VU5WXeulXNeb7d3HCiPEkU9EeIJWh6/N4Uw10w7ssCdaT
 zl+xL261
 lyHG9qcRdNYx18ASzlwG6Zbztk6h81Kepn6D9IOglDXweta07OGJnAQX0r09BPSNr6wJUhfZkA31MRzifWnF6Ug33KMw4n9Wbab0Z177xoFbOkkmgX1vbIUnAOortG42DMheb9CGfowZIUWyIIziCIKWDsFAV4Q+bLjpNAof0cB7mPlteWB0RAlwcwyDlSpxGlZu7dFdzPXOMAviheNSbQfXt6dZmj35UNNeZUE4GM3aNFzebaU8Mn5OpkbhDuUnr1IXr51aevfQlTCrnSHMdhunMwGzl7C9LMaak7DWg0BJ2OjnS7Wmn+MF3d+nYKOIjcMscOWhf/CUMBlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

Welcome and thanks for your contributions. Looking forward to more
collaboration with you.

On Wed, Feb 25, 2026 at 5:08=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> Recently, I have been actively contributing to the swap subsystem through
> works such as swap-tier patches and flash friendly swap proposal. During =
this
> process, I have consistently reviewed swap table code, some other patches=
 and fixed several
> bugs.
>
> As I am already CC'd on many patches and maintaining active interest in
> ongoing developments, I would like to officially add myself as a reviewer=
.
> I am committed to contributing to the kernel community with greater
> responsibility.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

