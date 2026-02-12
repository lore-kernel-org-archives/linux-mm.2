Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C665AEDF042
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD2E6B0005; Thu, 12 Feb 2026 01:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84FFC6B0089; Thu, 12 Feb 2026 01:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C276B008A; Thu, 12 Feb 2026 01:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 618386B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:12:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 943938BD80
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:20 +0000 (UTC)
X-FDA: 84434784840.15.329E7D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CC53100003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Evpm/Xp4";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770876738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCQ5qDsgBh4KuTxY/8nchh5KZY/Q2YUe0Ncv+qXRc/s=;
	b=tPbWQ0dT57K/VdFF+KQylmtCHR+N5zy4hmDXqd4UU7jul2ikEfC9oCa5aHZB5M9FEMqRWH
	JLuLa46XJtR2tWwusNsgf9KMf+VUEZWnlaCriIbg7HKzE4AIMexlkHWXxAAa8OqapV4t9y
	wiYUm7iqidyEKcF0ZwulIj/tjxLWuGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770876738; a=rsa-sha256;
	cv=none;
	b=Pb0ufrKFLWh3keaVEuKowZePTSs3Hf0xj3Ga7dDpUvm0NBXXkTPFW1yes1+t8azxzd65i7
	qgNqBeMzz3c0Dt+RznpTQOw3gTYai4gPgRpr1DECWLwDsyN5+Hd/SIPw9BaaeORAA/nYsG
	gFVeqiEGBjw4/OQMPZuHdwS43p2oAq4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Evpm/Xp4";
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A73C4444D1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4DBC2BC87
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770876737;
	bh=I9GrPl5Nl1kH2N5hDjkEf0B6d9RunWjXn3OsBvvn1Ac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Evpm/Xp4HEawLAca2Dr/IYrDMUB6TJgwKEN2KGZtkv5l5V9MiTi6M4pCKxW9jQQl4
	 EXCps9O10FaZi5iogL4zwAwyGuqKtWw2RWfIoZ+ykZUbM9BmdVzthIb64ZTZ178SQP
	 lvKdh/TUN/vEb9tSpKbQpyIZaKDQyWu5Vsvwer1yrRUg2kcebYsO++Cmg+Un3GvPL1
	 sYBvOilDGMOtG7Ua40/+KK5fWkooPI4hwNlK+TsmdkJ//TJstgvF9B9WpZ1s5RPTRq
	 8f77T8+y8v8sD4o06mFGLivACtUH29lIJJ7/4r1w+W1R4f+engrHxyfqHfDcBQPDkh
	 omvz535JgyZXQ==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7963a209b97so28965787b3.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:12:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVI9r0UqfO0Miq1GYtjFaYQq+PmlW9X0zmkw1NO8qJvHJpq8uLpr5ldhTZ8G+IMPbGz867mJ71F8g==@kvack.org
X-Gm-Message-State: AOJu0YxjD4Q7E1P/2cY4aJZCo1gO3sbdh6wQmRERL5IH3DND5LJgEx2+
	wFQeV/YCwRURh8zGc6O4/PDwmWCosJfo4P1/h36k0wup9QEQAceCn7L8HksXmsDyPd4UMttIubT
	XPdG+gsqN2NVmvxpfsOsb4jh7tly5A2eY8Wq0DsR0Tw==
X-Received: by 2002:a05:690c:c50e:b0:796:3124:6544 with SMTP id
 00721157ae682-797930a055fmr18331997b3.3.1770876736713; Wed, 11 Feb 2026
 22:12:16 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com>
In-Reply-To: <20260126065242.1221862-1-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 11 Feb 2026 22:12:04 -0800
X-Gmail-Original-Message-ID: <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
X-Gm-Features: AZwV_QjzITKiyww4DWMCdNMAPZSzThNC5YyMlw-tK6Rc3bhA13w9hO026qLdfDQ
Message-ID: <CACePvbU3OoGg5-dHXOJk=62AkBxJCLmzwcHdHuPe2nnxfzMLBw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9CC53100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: j8gwsxi9dgonk4oa5jtmf7ipqxccxycx
X-HE-Tag: 1770876738-264564
X-HE-Meta: U2FsdGVkX1+lGGeGMy9wtrrZlz/6zjnPeRtUWpnhBPO4H2WuS3KZK5qKI5w7zIU+Clvda0No6h6HPaIvIjGQvd2aWVfVx5oRw3nzzdbJiuR424kYqBdTsfS2UXy6RRiz6EPXf81ULac7ETW3KplFdBFZRFKmZ/KBjz/9ISa4X2Tua1p8nsc41/Za/vk8CMY92SLt47+imw+uCOCf6PbqSl+5q8EscvZnUQJ/YjxpQBavQpbk53NWaA7NqcY3HuRvv1z6E3WiiUOmYuLK3CW293ThN8MSJ/h2jcBfVzPWAiRZLLAehnfVaxliQtsAEw+wmSo200OFkL3EtgTtecW3UdYZv358gTIrfSwc99K73Rp+HqMSdXFU/IEC3tTNXX3h8LYPatR9Ac7dD9ypbjKx0mo6o9i+2ITZHFTtotPGFf7ZaQHLWmGdTU5VO3LwAgZuIUVO/f0UEbGxw06tA55SjCtjMzrj8+asVEZTZMGlT8CuLNMnN843+rPSaQQ/ZFPdL/I9INjWNZQrkB44ADXpPaxx0P+fNF+iD5p33MCXRmF0XmQXC7aNRPG6owsZ3k99e/g8ZqVasekWucij6gF7vHtfiIEciLudazWji24dQXcG9ZD4RLs0Krov/eXheUB5xxpJNb6vCjQXhNdkU4mdLF1LHyKuf66t1fu1dicACNueFMfQTt/RN/+gK6EqSrplQHgrMMrC1kfT6YPMa6mVW/UtwvL8dAVsFyE7bYO+YgekUkIjoIqQ2kQnGNnaMgL/prqqaiVa5zvf0CInNHPE17UMQQlI7/hS0cGDz+OzVjDBWCveod/gFRpAnFj1LyxtMAuiFWy5cO8Udr1LPsyJF6tbTdInHCusBknZZM0WWbcOhbSsqI40T+acNMizhq+c94zm03+p+OrgkqRwzsbVyAVPd2o0Y6p+fK5c5skV4Rt6OCdjZt24fRPuhipGwpIUqUmxvHqgll+mqHRq63y
 6cxSPqxR
 iCXg0/ISwGDrOmZNGzbPmFPPxSsJSwaAE/bHJJSWfJWpsVH6/AQKPEzbUtrPzWRyUUbZjYgQuo4gveais9NuDykrxoacFuiHChMrjm4hDehjFsflryUgcFcrtgKgKJ5QMhSj4XqrHhZobI+qLbXBId+PFiAtxOr/nHy0Ltnz8Nu9AtmYAARrN66IF8Sm9+TfbXona+53PGa02z5QI/kcoN+UknJFQpXM6rW9EI1Zv7nko6jw1sASfYBpLN0oEYkKXHGmOA0f+uEEJuTF5mINVHkzyUBcAl6CzyEutgGh0SNYnB7G/AJWXdSDuJQZA/4E6co+GQXTToN8MI3I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

On Sun, Jan 25, 2026 at 10:53=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> This is the second version of the RFC for the "Swap Tiers" concept.
> Link to v1: https://lore.kernel.org/linux-mm/20251109124947.1101520-1-you=
ngjun.park@lge.com/
>
> This version incorporates feedback received during LPC 2025 and addresses
> comments from the previous review. We have also included experimental
> results based on usage scenarios intended for our internal platforms.

Thanks for the patches series.

Sorry for the late reply. I have been wanting to reply to it but get
super busy at work.

Some high level feedback for the series. Now that you demonstrated the
whole series, let's focus on making small mergiable baby steps. Just
like the swap table has different phases. Make each step minimal, each
step shows some value. Do the MVP, we can always add more features as
a follow up step.

I suggest the first step is getting the tiers bits defined. Add only,
no delete.  Get that reviewed and merged, then the next step is to use
those tiers.

Chris

