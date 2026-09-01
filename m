Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B52B3C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31E16B0088; Tue,  1 Sep 2026 14:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09816B008C; Tue,  1 Sep 2026 14:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7B06B0092; Tue,  1 Sep 2026 14:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C5C6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:04:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0B401404E8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:04:38 +0000 (UTC)
X-FDA: 85165968636.15.E0A3226
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id F23BB40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:04:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aEuboSUm;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788285876;
	b=bOAIcfGzD+50pol/7rvPrb71mtUjcNvnRVLUgTYOzKHD7MxbyM1qvyMFLbPlaiFvlbL+Ns
	IsJLfu57BvRtaXz6GIARumaVEaQw8EL0rcw3iHyg+6Nswz5d87p/8SREFlvO7qqM+qF98q
	R4cDUjIY/8qRUGARj2Axg3f613xXVng=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aEuboSUm;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788285876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUVVEFTVIn467SJywBoEi/ks8xT0q4iqiCkzqcTtTlw=;
	b=mPaPy5tse/0Fx1Ql3ay18idws2IHtC07qMSGjKJ6NjQ4wDjXL1phfzzSxAuBG7aCgoT0tN
	ml0OJMfU7WxJxX8A7egcLQ1y0pqU4RmccvImZMlrJ3EqZhPE2/Gb9HZNA6mWj4xJclv+S4
	ZWK7V35P3pmVJn1EkvrQ9iaUiBt3CQU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so673935e9.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:04:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788285875; cv=none;
        d=google.com; s=arc-20260327;
        b=rH3c4BftMcpwQRPzEB4u0inRT7mgp8nH3DZ+QgZvw3APVKy4vaKP1YLGSkW9UTxyLq
         2GfLJCpgM1qrE9f9WSS3zcTDTOGuHOaio+0oNRCIcQWvbUQvkREhBzDcfU1G1Y2HlmWo
         uxZGCU3EHGURHVhz+Aldq0t2CWevOYqF1SzJ2gQ/NV6GTKnWZzcrZGSejAAHCy4u6J1T
         WPmhNaTFrruZeoxHwDTzvwz9l0rjCszDc3tcgY3daXIFcwh8SiZKOqknqO0cvy0C7rR1
         rnruCiJH1h9vrDVeBbwzxBb5js0OKZAL04crQIg4l0dt3FMaA2IAvpTH9OYzORqwPLIN
         YbFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hUVVEFTVIn467SJywBoEi/ks8xT0q4iqiCkzqcTtTlw=;
        fh=XPB7Cjrhsa/GUOErhJlySARlfDvgSGmtu+Z33J3Llas=;
        b=abbcWTL0WDtTI+zUBuRcXksg0UtKT66Q5+gAdYHkectCV0tnq8I4DClb3v+2plLW3Q
         FJx2J8GUTCyt+Um8qV7CK6f7c92vM5UrvKiGx6uCySNM1kI5Jnh4xmybcB1zWv+QeUMB
         Z6Lio/OCdBh3wQKmDpWLCxKkmi2vQ+V3geWzIkvfYRIVn6b3uPOUelURXOO5MRK1uif2
         b2HqLclUt86MdG+0hU4zyWY0chGS/3kodpd+l0MXyZygJnx5pk3zwlqypaEtp/Zare1T
         B0RkcIld27eyNLgvssiNvSpwGXnskvVoQ+rhNBTYgOwHmVvUbSpRtAONjI1KJAfaUTP0
         9H+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788285875; x=1788890675; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hUVVEFTVIn467SJywBoEi/ks8xT0q4iqiCkzqcTtTlw=;
        b=aEuboSUmUHQXAo/SXD3858YLLWvFTz00Mum8xZpXBN/GKdmVOVn7gBjQW6xesamicA
         yh45u0TMQHDbsQMz+ihIKyf9avOIMJ4XerkTde59bfPs7xqpyZzcafN7nScQwfHtKRAX
         SoVaiGm6YFVz2zXIImJ3J2nqg4zm1grEQ3i55JvF3GqpuQBMtzjmwIpf/a1aZauwmXWI
         DKe16gB+UJXVlzJECXGRfdKDnx9mOdTWJWDK7mRw33oQ5vysBfreEWOGakFKgaTi2lbL
         bNz2820EtwPgofvxjd8pKCK8DBlJipaznPTeolf06vf+iO6E5dXkQGa1fUvxEWwMZnBm
         7ZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788285875; x=1788890675;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hUVVEFTVIn467SJywBoEi/ks8xT0q4iqiCkzqcTtTlw=;
        b=geAer9ysZbZKJ1m0nCqMtZM/Of1ejZjVjB1ftlOKXlvLC6TGagNNVgNFznb1V1v5H0
         fuBWAy7idwCFyPSdtKeO8EBYJR3aMvPQFFiAlwNh84T4C5/o7C69j2bWVFu2wssi9/6y
         tShSMtuHzqf7+DqG0/W6q14k9q50nsEQDit0En+ydEAtoLpLGwJzGZpZ2LnDl2HKgY1R
         dlViAHg1ArDJjw8ZUYIkCygPHLc5Ot4WEWSg6gZfwoGDjEnDbsWgcG0ggWZHVdilRxkx
         zq9zkiUrjRHOlGXnx3UImoLmCAwB1d5AKOAeLc+biRKStYs1i4q1JkCR/0gDALAVKe7V
         7L5A==
X-Forwarded-Encrypted: i=1; AHgh+Rp3qpKxesxR4iVf/s4WA0VWshgqZHBYKrsWeygiNpt+CeR+goX/snbNlzngppGYASLRLJ+BhrFjOA==@kvack.org
X-Gm-Message-State: AFuF++mE4STtupSEYsEEyKfQbKNuglvZDG6fl3GNG9gSWLtZPepApSZ/
	l2vO8XMREVMHvDc10HQP/iUB4DgV1ZCHQhkCfa8ITorcT5//XAh3nQxdWUCkuSaCSRSug6LwOyQ
	F6Xrq6GzNaSuqnfaUdYjdYxtoWwvbmvI=
X-Gm-Gg: AR+sD108LPsmWnBOf1n51hq3VVSQNBvDIQ57ku5HhynwPq1J0DqfVP787L1PpuW4M/D
	jL04pAkfQwC4NJeHyMaw8lQuHCfoQwH/st9x3cm1abxy8Yd3dgb2doXIm/hw4JxcmpA9ePCWm78
	0fD7SflQmL6lptmIrJZPWBmKN3txRqcC0eGfAHX/9gyH0sL/0IoFBZUdL5AIAf2XScWjlWv5zAq
	2b1+5pbJ8WoGc0jpizImAzuOnlpn1pysxWp65ZrCEZLYs7/2eRqqpj6aJv4tNRcqOc4EwJDCIuG
	WQO6RIGstJ2Q6j52Mf6YHuJor2CEBqfCN2e9+ym5mNKe5ZwlEpEznbFed9bTmXW9vSDUEpWUoxC
	tvzQ=
X-Received: by 2002:a05:600c:a012:b0:49c:d818:8764 with SMTP id
 5b1f17b1804b1-49cd81887aemr257261865e9.11.1788285874997; Tue, 01 Sep 2026
 11:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260901161317.3468233-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260901161317.3468233-1-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 1 Sep 2026 14:04:22 -0400
X-Gm-Features: AcwNN1VidmfJ5pX46qChkksGP0fJtnDQ2Hgbr8MA8crLeorD9MO_R1ONtmYEAUQ
Message-ID: <CAKEwX=MD_EcAaLzMGnMytVJ_KTGmv=hpR2h-DD+w0oJRjzkg6Q@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: Skip test_no_invasive_cgroup_shrink if
 zswap shrinker is enabled
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, cgroup@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F23BB40002
X-Stat-Signature: ghx3dbr8hfjfua1x5pj764p1175oseux
X-HE-Tag: 1788285876-355234
X-HE-Meta: U2FsdGVkX18KhlCZnNv0UnEfaZ+6zk4s1dodPJMnf1lmD2IRwn47xxmf542rKRotynoeAKOs+U4vNFOe2qupK9Wq6Sc8o5uFjO188VfX5vM9aL/18SmjAV4+Z5+f4NWRdTYio0Cp9oJI9nOmMS/6pyMvmII2Bs89XZkz1CggQa5BNNeE2lp2pWWWKae6vHj+TXflZutOD7j1t/52N4OyvsYvFhsLwyA+nSF1g18xJNLHySontkg/C2gjGn8bEPBQ+QFshfO9mxm3CSDYPufwTn5I61FqhQ/vrK2wjFQwISzInkh+k7GHRyO2sgh5XSMqrgx22nXlnLEF2jX8DVZxHvkVLDo6Y40BJd+QCu2W6j56D9Yu3KfYiGEzP9L4bl4NjZ/jHMmTpT/3P8CZ+oh282cw82PZCn+09Nkg/PHqu25qE9YmeKSyae5HMz17+GH8iEZ38/5T/Gqx0Isg9DI+vpEWLkDGJzxLpEg8b9L6qY0/YqvI1Xzox49WL6dLRHz3255hx3M3a6BisAtmI58y1EsDmNt8tcBiPZdIF962IC1UMlqt8E2wj3VQcQECb2IN9hKmme2qXvcFx33aVTypH3MX9UanV0ezQ3m1gzs09/q0ZVi0wB+Eyn0cB7W6Qv5ezr98+vjOc7t9G3qCFiaKoMd3gIDf2UidCpJpuGoBy7wVe50u5+s5BFXr83I24pv6UnM+5oNblSKmVg0UU/l/J462a97yFCycvPvzxu/Whmnx7XfHjmxsrJSkn4s3NjbIjArgLDjrGr3Vd+OX6nc+UnUbwUyCC9GAs1RQo6VKZFBHvbTR+LSptQb4x03cp/GhGLGCA+d7simQtCPRSxMI8I7JnYTdFqvaBNvYAYIRvG9OVWpYpqnYlQR/7fc4Aobk5cGKmZmwo21Bwkbzj6V7AakdM79D350lqb38bslpExCrvxvGXAvRhoH0qBEPpFNPF0Ti6hE5jimHRBAbOqf
 /xR2V/d4
 eCcZp9Bh5ZBdD48QhBOftDENtSXR7p8sqSUF2sIex5WoWPS2a05z5cfZWRrtzBRhqACHxL6EeIzcDiAFvM5LvghVHmcGpvCfAz7yJ94ZGFOBwlWRBadm6bYv3ap7drC3c/rBOSdsbeTedCcXnbVDpBXA67wNXfv5mdfPsNKUEQuLenQ84eNLyjraLpGDZvkrXWjmVEpHFunLHTRvK/qaC7ZgXd+ircLJ3w9ZiKxHzwn7FTVHSXEaCa/a52cw0lO3n+9K/dxN5HOlq5Xq36+pcgM2a4KmWX+QgmvR/u/+67jCfJGRExXf7iXXEHOL+LiW1CmZzA/0nDMD30IVyeTGYjob39/KcszcTiV8ML7NEd4xtzXbi4s99p1IKc3rRqxXsTk/MnbjOCny/oPnoeBF+RTtuiDrROw9w0Qei7xU8WyLhlIuYXlHaElGV1bwTv84EnD/4gE4tZ+j5QqFShvbf8WHwILuNAajPAfkREwkoDZoYu7qvEdAbkWkIc/HNrZn5y44YvA+KxDst7anzXPlhGMHXmbGnIlcp7z76tqGGK3qDFLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 12:13=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.co=
m> wrote:
>
> The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> has zswapped out more pages than memory.zswap.max, that it does not
> trigger writeback for other cgroups. To do this, it compares the
> writeback count in a control cgroup and makes sure that it is 0,
> and compares it to the writeback count in a aggressor cgroup who
> does expect to see writeback.
>
> When the zswap shrinker is enabled however, there is an additional path
> to zswap writeback, which can happen independently of reaching the
> memory.zswap.max limit.
>
> The writeback counter cannot distinguish between invasive noisy-neighbor
> driven writeback and the zswap shrinker work, so the test becomes
> invalid.

I think writeback in the control group (zw_group) happens right during
the first round of memory allocation, but there shouldn't be any on
the second round (as the second round involves writing to wb_group
only). So if we read zswap writeback counter of that cgroup (zw_group)
right after that first allocation round, and make sure delta =3D 0 after
the second round, then that should work for both shrinker_enabled =3D Y
v.s N.

If it's still too noisy, then I'm fine with skipping it when
shrinker_enabled =3D Y.

