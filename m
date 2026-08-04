Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1C1C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC136B0102; Tue,  4 Aug 2026 11:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D856B0103; Tue,  4 Aug 2026 11:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73106B010B; Tue,  4 Aug 2026 11:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD8E6B0102
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:55:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24864C020C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:55:06 +0000 (UTC)
X-FDA: 85064035812.17.879E935
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 99BFE40009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:55:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=UXM7lhsL;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785858904;
	b=lx90YsIRNdpDMuAMjqfbX4boz6RnNfuGs8S7i6htCOeTniGZl7UsdrXMKu3V8LK6jCeyne
	bPHVHEdKWclSX6E6pVdZpE7SeAao1nMWxwIn8bz27/Vu8Mb56YocMstYxBNMxI/TrKQ0FY
	J6KubXESFUG289P+0J8NpLm1Q0M3HOk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=UXM7lhsL;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785858903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4xgJp2B/z+NAqHhu5Ojm/1pvtssSxY1YUWVWv7CENo=;
	b=WsvyWfTTkrtfbRow+/J19s/q4kUPt/E8jjec+O8ADQ44qxJRJupT2lSPe3YPI/tBoDdx22
	Xam+QKmFX412qPPrwN1Y65eM9esfr3C1gxXmOa4vySLB5w+UsieS4us0H20V2FwBRROMQY
	oz0JkjzkOSiDvtHzp56E4osZo9DJaNA=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so7556166b.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1785858902; x=1786463702; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o4xgJp2B/z+NAqHhu5Ojm/1pvtssSxY1YUWVWv7CENo=;
        b=UXM7lhsLJ1mkSyKGzi0IvaA6fhah2Ff6PSNX9TRwmgjrAk4mPTVHurrJTY7olLl5MT
         PZOOkBuhelABareW4AiFbES+RFEe80c1XVwoY6rRJGOZ6O5Q3Zpizaey5p7w9PsKe17R
         awfEY6jImlLGCqFCPwMNqZbi22eBagFwFS/NA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785858902; x=1786463702;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=o4xgJp2B/z+NAqHhu5Ojm/1pvtssSxY1YUWVWv7CENo=;
        b=Pzewacutb9mTCWBskmWPkQaGsmwe4k+47R7wk4Ozw0pTx1dDbcigWHWZznGz5thd7f
         5EV3CELMK961YNSj/0kUW9KW9P9A/mcQ14lOB+gNjUVHpdap97wjzT49XPOBA8yzm3eL
         jZEheMS5ZHM9R2GZ8fcB9/72aQlRvFezMKQK+6MJs+TnZGNoA4byYpGsycWqrDEw26ia
         fKk2LHqjyAJ5f9ecyp4nkjO/mLwQDmXEczA2ruktHa97lDOn3+XJc5ZK4/ooizdsDR9b
         pISSCFIuXl+6rArpClxMt1PMktpupxHql3ddLXrArBtF45V3JRwW8Ov/Dxv7aUxy/iH4
         rjLg==
X-Forwarded-Encrypted: i=1; AHgh+RqziCCkRIDkFcaPtGcki5TIKg8QC98YpAlNm23+aYwSk4EU7BVzmklB1p1i7Q19XwU/lsV1bvcTQg==@kvack.org
X-Gm-Message-State: AOJu0Yzx8+swYKVpjyZ4fmBtnK0XONC9CGLwd+yxRfZEig637nqgi8sb
	igOtigKcIhiWPa4iei7Eic/mIJQ9RGuQiARIgE6nJsXrM6mxufi8T5+cCh9rPdn7ynblR6DCdb8
	9B5ZDeT+vtQ==
X-Gm-Gg: AR+sD106kXL6ecWt1QL0uj6fn6Gw0rgGotEEgHhTFUdpNb3JataPlvoJKusOFIa3TmN
	JMA4qrYGxYN2gvgupV6kWMyoop5/P4PG7ywlZWGDpIUQdSuJu33cijJkI0kzWx+ehBE5mJUdmi6
	fqKqJVEXXBAA8o2u5tA2WiHpU4kihs8U6TmM3g+WwaE0p8dREdJKQ5QdVroiLE32q5WZ7V5egIS
	aP0KYqZDvR2hF6bLll3IynfVhyqA7UYSc0+aKb4b+Ldak7/YWFoOcHCviZndeQwWZ0jfQ0W+qzh
	KNyGfemzzRZKShTmSJo5zLWNNHlUF2HoGC9rDTaLXKWojuD95VV2/9qJ7N52G1qz6jHb542Jzpo
	tBsMHOsLwp48vriIUE7JsAWLUkryWB+j4Y5qzpMrO9x6J65OUDxyCdwAaZO+bfnGbE7pDJe8+5c
	Nc9A9Qi1xH93YcsVlWXWcAdF4GRSzUp7fodoN/CKYI8T/Q7usAiihYWtRgUtfikthkZXMXKiUjM
	0zCqC2lpId53M/lAf4GbBCrTD1Naptu0in2/g==
X-Received: by 2002:a17:906:5054:b0:c1f:983f:d8a with SMTP id a640c23a62f3a-c1fe7f13483mr1057641166b.24.1785858901982;
        Tue, 04 Aug 2026 08:55:01 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036422825sm31269166b.43.2026.08.04.08.55.01
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 08:55:01 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c1c4c7ddaf6so7551266b.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 08:55:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrqeRNHDJVOhSwVqMtC8qOZN1AEA5Du+PEQVGcI9HjTinvJooU3p33DZKbbJ3ZxboOUmyOZU+eViw==@kvack.org
X-Received: by 2002:a17:906:5ace:b0:c15:a487:3482 with SMTP id
 a640c23a62f3a-c1fe7efc4bemr980444666b.21.1785858901284; Tue, 04 Aug 2026
 08:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260804003708.49830-1-luto@kernel.org> <0adaae9e-7086-4213-811e-ba6e4181e145@kernel.org>
In-Reply-To: <0adaae9e-7086-4213-811e-ba6e4181e145@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Aug 2026 08:54:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com>
X-Gm-Features: AUfX_myhVk8FsTTBsauy1SMj6wBQHUdARrPzjNn3Fs3t9DNtnJgmwbJSdme97Ag
Message-ID: <CAHk-=wiO8NDCyBYrDMpjh8zMKnzgD2XuPYo0nk4Hwgq44R_jKg@mail.gmail.com>
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: luto@kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 99BFE40009
X-Stat-Signature: n4bxjo11y7udysoknn9eokz1hz4551wk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785858903-756031
X-HE-Meta: U2FsdGVkX1+ohnqX1S1tlUE+Ay1ophiD40G/mQMggEsIjiF1hKB0cih+mwt7Qp56qkJleDW7v0vG4IZGmqtd4FB/MFH+6C+mXlPZgnJhY/QVlE3gdHIWvInvaxuMV4fB9VdOMMOAJkc/x/N1vfu042jOhiJJ+TDQvQfmjQOgP2J6zNM58c/phaPfXlKtVdnDktzO7//MgC+Rl51+Gkkm1nxQDmzZgrotb2QH41xg653yjgomDQK5s3VGnfyVRCHD6qQPsfFfafgwoeZdZ59XydngnM3LXqMZkBsSU//fXSO0F9kkqFbJabyVbdGpCI3/aVLdvJVfUSmXN7p9H3Tebcmi2iNIcqRtlRXSV7+EKduEEmesseqF83dOc1s1H8ls0NWC6n7U0vuUNahkbdvNyQ/lZRKTcren4JhdNd+7OzwFo7YCXoPCWHQ+XWCAAV1+VsTec9542IjmvVrI4OSEkohPJNCIotrfYy/e3ZQSHWgCF+O91EQfEIK7TcnZt96iUOVdvCwv3aX6Aq6lvzuYtCIpqdsotSl4wmKNBAxz9j3lNqNWDzSAhBWC0fojtOH9I4rN7HXQValQyNdwxqEnYcv9Yv9h6RwPr1ay2otTpwrWfuOi0AodIsm6oI9l/ptp0aMXE5mr8+aLFYIR05BPNmWKK8e0iRZnbfNpFxn3CWz8+RdQ1WHJrPcuJVxDCKZDxotheAISaHATfIX3DnMZI8Rg/VQPvgoJGvrgpbkgoB1Q8eOB6ugRsnoE6actBsRubiuBZfiKrkTlJw1JJSc49t++21J/Ou69/M0jloALRVgWuT1bma3gov8dkAJt5HraOPho2ioVq1tmv+sIGImrOB19yvhuMHkAcekr7H/j3t9ktDVNv0Ut2bWWTf6xM4+X6ZSzEvMWkj9Bsq+j2EpU7XVW2X06UrwIv0B9JGn1XlZxsUIxoCieo0hCW/ehcg8SofC/Lp4FoExqdf1CLDT
 /piWsvOJ
 gbME2VmPAMPPRROkHRM/4y7lfaYiKb/BdoIQAIRjrIZv+g7qBOXRLixeuEpEC1gBLrczrpEjtLftpbq5JnfGFGrBaK3qRPSfJeFSQztxoe4DAbvNt4lZNyYhAd+iIMXxvPAJunhOd/KRsS6JF6niPINkCLuxnqGOCyPin21w1/3sGtQhyB1xrmqgoNV5sKzkFgxE+LAY+vV1goOq/P44vg0II63EC1KrrPS8Ejb7EI0Xeg7+rtf+cSXIRxnGHCmqNeZfnnZ2XV8I+skVFjDNA9lnY+AOJTfitOPK/Ie+3D6ULH0w8S6KL/04UKL56iJEY3MXH5NRIWeq0+yigX7dkIO71N0ZvGozq3g64/hc6BDCV96dXisqZXR3UJX+bfBrNfeyq/BstU9PRGiMS5GspeHM0sQ7ICYOOgk91pDZURgzrxc9ygQf/S3fz4u69MKVCyzpArkBo1a9ETGB/oLA840zfmfmOzgWM8bRh/y1/WDSbpulcovyoJjCm6fdYwFodB1WbvBdNDRvsxQfGLQWqZxsI2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 at 02:49, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>
> +Cc Linus for nerd sniping purposes

I don't know what to say - the patch looks obviously correct to me,
and I certainly can't disagree with the verbiage in the commit message
either.

The fact that the current code looks to be *so* broken makes me a bit
nervous that there's something subtle going on, but I *think* it's all
just a very non-subtle bug and it just happens to work because the
whole zap code typically uses the mmu_gather infrastructure and other
things end up resulting in the tlb being flushed regardless. But
that's just me waving my hands so wildly that I think I had lift-off
for a moment.

                Linus

