Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 407C1CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01DFF6B009F; Tue, 16 Jun 2026 23:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10DC6B00A0; Tue, 16 Jun 2026 23:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF5F6B00A1; Tue, 16 Jun 2026 23:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B59986B009F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:38:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26F39120169
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:38:17 +0000 (UTC)
X-FDA: 84887996634.28.B6C281A
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2943320008
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:38:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bGzKNak3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781667495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml3xcOh2MxfIz5ly++h37MpYhzCflCK0dlrikZM10nE=;
	b=RDbufS2a1AHhgYZfU84iDr5nesHl5mjk43/irsN9ddGBxfzQz24Q+y1U2h4JeNR4+K4U/c
	s0Zdv8lXx5fTE8ZXcABD68/gC4gNlHAkEU3xdQJZO5VT+qXd6zfYvjWx4tgMEgNywkOD4n
	E+eWR+S/I18f73m7PthVvIFZ/yp/ZxI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bGzKNak3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781667495;
	b=dxupJAIejKnz3//lgLfTDH7Y3jZvu1zrXCNIYj2W2f06RtP8ICdM8BXWUH7WB6uXOKqJq1
	FSNNrrG7Pqr4FLS0wiqYoATBblnkpO7OhuGlMM1ERAu2XL5o2BtxxPn8L0l+5S7nz4Dt4D
	7O4eZhKoLx0ctd/Thlbw1EWAUvw4XxM=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39657d28132so39652931fa.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:38:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781667493; cv=none;
        d=google.com; s=arc-20240605;
        b=Z3I927DPbbjNj7ujYHdcGhTFyEtC8cGpzTnL1E/iFAEDH/OwaiPyX6YJpCz08sbM1U
         MmVU19uYbWt9xa9dECK1fhpJmjTbwl3SUdugYejr9Szu1THi2Yjy0JF0fFFj/cxRma+Y
         nAWKaaB5XZKh+y97yYdtpxsqpNM1yoK2nv4kblmmXppRSyow+HgN2B2i97/5wYa1654e
         D3GFJQYhHcdSqV/rAlMGA/YCBeQ/1xmcSMgXjP7q8fqSVpq4dSUbgVusiHTmFHBgd9sh
         Qrl1YR77iGJuhCf9P+dkLaCiFf7P6+u85pIpmz+yuRSaM3B8IvlYrQrrMN9wB2YeWMMw
         DcuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ml3xcOh2MxfIz5ly++h37MpYhzCflCK0dlrikZM10nE=;
        fh=SAKTs4A5vuT26XdmzFBn6qlNKmNqEe8AX5fBIlh0060=;
        b=SzPI6WGEuo3jf4/X1ndWsUxjj42SYPzIMNCcbHG+CJrnFZRqmWbIz8veCY0gzTComh
         Pd0vLD9a6et0VUrErTDeEKPVq7fAVFbPYueQUG4hvAfcZNwEJCu1LonfulTMby1we49B
         4kxoLbMPtrhPP2zu2q9uBRIIS7nzIFyP7MAkNrATphDAnTHOrD1cYx/Dzzjih4X0Sev1
         qp5RDk1bXqiXjSmHU+AE0JjyoWnxW3bfS92xeI4Nor2iOd7scQdjbrcAtQ6CigJ0lRFo
         9aFHElXLIYKcIz0OrO07w3n1iR0p3dyZLeEAZ7E2AWWVdBv4L/6Lc0XWm5/Rjlqh2jYi
         7bGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781667493; x=1782272293; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ml3xcOh2MxfIz5ly++h37MpYhzCflCK0dlrikZM10nE=;
        b=bGzKNak3OcAgDWSCG63l5eUoNP7cCPiNUGUJeM7zs4zD90w7Pwe1v01pSu+6Zqq5Vc
         lWV90FgH3RzoGqUTDJJaoZ2LysXlMFEob3M7IBRMKvUX2pwFSjy8UUPirs+Mk05O9feY
         eaPbsaPLBe72WeEapIjkA59MdLI4HCXsY47ziSUTtqJwy6BECBPvQ5/xddTurYVYUyKw
         tTkJpSRdWOgrRXSFP5LtNXpb1NZM0MkW2qdYfXq1v6cD4PaLGpSdtaQVeZRC51dCIV8k
         CuV1w7twV57PrO0KJx61lx72b9EkX6IDz3ItZaFJViCq5jW/lC5tEuXa2AIlRvSF5FUN
         1sNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781667493; x=1782272293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ml3xcOh2MxfIz5ly++h37MpYhzCflCK0dlrikZM10nE=;
        b=pNaMTTIcj8We/SH8Rpo0Q91Ez98kffUtH06hohBmPbvNAS0OGzJUNb3jJKLd9frU10
         X1MI8vH2xlkHujvFoLltsHNw0bOL3rc+lJ+6FOS1GeBoibF04vYEXxU1ECfV5zHETVJm
         1vj/TMxTf6fzGTR9EPmPd+BJlRWXKhkwj2J/lb3Rn1siZbcsjv4Uv6x7Y41P99LR1Zs0
         LE0TUKwLJVtbg/RTZs5njx4U5hDcQkJW4cPZSAjPV0yfgM84eA2WcHPayFc//h+UqCil
         eodyOLvG103arIHDZcWFGmPcImw/CBDtfNB+DRr+CsJGv0CgGBXNzCHQKbPgsDN/zYDx
         Z3Bw==
X-Forwarded-Encrypted: i=1; AFNElJ9hVy01LKozp6mIanM7t3owAiRyjVe4YT500+0Jsi+34/AhvavLSXSG+dbAqrXq8k8xdN5pM7EWLg==@kvack.org
X-Gm-Message-State: AOJu0YypIGo5I9+ZZMk6ktpKDQDg15wpoEus5+IAd9e0N7ZWNADbH+i/
	7Rm+Av+xRLUzJi6qtLFCRZzAe5Yz4Nd/Q4mvklLFCUpRo7DsUjVh73hTQkCwGoju2jhhPNp4Hnr
	5cyXsXzB8GE6/Fu/iyKpdMDi4zLsBwuc=
X-Gm-Gg: Acq92OF7dYbZ6TZxz4jvdGAbQPeRmJRJnyC7jFfBnvuuyBi9092/LpsiZNleIjJg1mL
	MQb1TCxgJ6OULLjggsvcaVRop/ms3eYRJ+hgFFfUdohtKotbYd03XNkwl8qyix8u2vpNv7HbtWj
	iyhT6PptN01xvGDJsH/RfMEBrBD0JMrOKxAgtwJPOQxs1pnOklpV5gcHD8GLLEibYo9+ZV91NfE
	SmNX3OC8RD4+L6LlzuIxE5kMkzFeyZF4QPRutUgy/IumXQ+lJnZ4WgviX6oVR/M2FnKSSpnopir
	8/xQQdGF6KIHptPXDDuIIt4Iww==
X-Received: by 2002:a05:6512:3990:b0:5aa:500f:7bae with SMTP id
 2adb3069b0e04-5ad4701aa1cmr506325e87.35.1781667493023; Tue, 16 Jun 2026
 20:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
 <20260616123646.GB21024@lst.de>
In-Reply-To: <20260616123646.GB21024@lst.de>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 17 Jun 2026 11:38:02 +0800
X-Gm-Features: AVVi8CciGk9AEKRBRV_ut2Q8RKhgWQ0siGiHzajgiKnai1OCYfaSoTtY1t2d4Zw
Message-ID: <CAJxJ_jhK+zkpjhs3YsQ9RoasKYh+E0NweQci0sPAEY1ne5LmBA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2943320008
X-Stat-Signature: 88rfoq3366ebw8169meef3sfjocftnpx
X-Rspam-User: 
X-HE-Tag: 1781667494-871810
X-HE-Meta: U2FsdGVkX18zWPrI47Rd7lkMwO09y7orGU6zcMkTCeguu49HD+hjfyaeidr498tuwkr653jMDPNqtmnvTri7OYzPyBflKZuBdxLJ5UKEi6OcEiJqFVSsL56BJmFV1WYdJPN3V8WNPZGELbyw33EZCRv9HiyXw1S9r2Ot7HQSay0G4Qs9X4k0TXp4tnSI/G8RIX57YEEakO7vM34IYNJsoU18TWoUxVjRMdLOKR2lllh9ZjM0/2uHeYl3ASSUNZEHkj7zDeWnP6XufmEmhLP/w2XkWeIt5P3Uzbbzpc4EzgCUn97GJic83kjxx2LZgRHqGnhMqrW/13vWSg8Oi2cf6aeWpxfWzgOjNEm3rpR7pXEm/yjRAJIdv/eQaHnHpQfughaKB5zS4xc2eX46YtutvRdL6yGzQnFAwZuGYybX6PANM9YXpBty49Axhxx/sK0os2C55SrxmExF8KQ6L/VOu/TYcRktnEixnt4TOA/y1PCtJ77k4LOpDFgObKAecMhLpMCp+uA7ptOwJigqxBgwBrRKTJ1ZX63FPVTSIlYArWfwHBuGy0tpzzRqlRwlfApdsLPtg8IGISJa1f/LxvEzkZE7gV3q6QyEh4eNaIfBXAEI8Q+wGyjfj6ASfHwP/MkqFD5ukQXCqk222OEOUuOOkxF46iEuS1qr4Of+MYrrQbpmQg9Eb/EX8mQBHcYx933BfNmjyN2+hzYVjQWjGHEyDc1+1fP+mJNQ/+SlgO40a77eChrBi4jnYz5JWcTOMYdUDGDLVW4f1t3v/lnkBz8nul3+k4/ZzxMGqqVj9Bf+baUNV3yOxecGniJQhYc6rcgq6FYMPRiK0yGHRKVOS51RxW/R6iSMSNyWc6Hd0Tw1/iKXBNT7LwZBexzFswJ4NO8EwlhxVSPlewv4jUQ/9NlUllb3jkD1W2qNrV7pJzVTrHoKIeHuXwHQLKK3Fn+ie6kpTr+Qcg5Z9ZzNrp4QoDH
 hENF4MlG
 X9uy2QAld+8l4heuqOD7QYxBc0gbSrGYO1vyuve869YxJMHj+GJktICI0W/SZVgpF2sva9eEueyidBSuq8X3olW9/KHb7xGEfNbhC3a7RuMrFFK4ne7Bi2LHDLXRBMkvgzXV9ZVu3CfdddaQHEYIh8MRn2I0zQficWlxl3CLsTWvTdQKRUKOXzz2wwHSYyz4YMAI2xyISqeNRD4Oow8XFVME1+zVBLsnpt5Qg+qETlkGaplodyUJua6BH+gL+ytCwxdXV889ZVKUI+t8V1taPnKrt73mBryZcH2AHwBUdTlXdx16zysVUEyE/vKALIIxnoJfAb0eo2L6LHp9frnLHkMrQxF6+nCANI2ZT6LoiPov0UYFzJYADPT/F4y35G9uSC9BlgjjExJuft/awRQf9GavwEQnl26BqF5Wl5/xAP372k9+SXY7Ng0QiYwI5rx0JCe4xlVqL69w1CT5Xk1yk4LlpSsanE8d1yXmW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

Thanks for the feedback.

> I fear this is going entirely in the wrong direction.
OK. I was trying to build on your swap_iocb / swap_ops rework
for the zram swap path, but I take your point that compressed swap can
be handled more nicely.

> Yes, we have to keep zram around as a legacy interface for now,
> but the right place to deal with compressed swap is in the core.
I agree compressed swap belongs in the core is better, so not only ram,
but also the block layer can use it.

Before I rework or drop the RFC, could you outline how you see that
core-side model working? In particular:
  - How should a compressed backend like zram or future block device
    plug into swap_iocb / swap_ops?
  - What role do you expect zram to keep while the legacy block interface
    remains: current block swap only, or something else?

I am open to reworking the series toward a core-based approach once
the intended direction is clearer.

Thanks,
Jianyue

