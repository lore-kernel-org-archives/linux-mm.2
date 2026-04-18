Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1673BF99C7B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 08:17:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2846B01A1; Sat, 18 Apr 2026 04:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345286B01A2; Sat, 18 Apr 2026 04:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0296B01A3; Sat, 18 Apr 2026 04:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0687A6B01A1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:17:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0159E4629
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:17:22 +0000 (UTC)
X-FDA: 84670971924.04.3A3B5BB
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91260100007
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:17:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jvox7hix;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776500240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=osHl21ka+EHE85SfgVEe4S+Jtjdn7o2ijvj352s1WKY=;
	b=o2nUk6mUJIGSlu8jFNvrf1prYkHKZ6YW+WAGF7WoxNzbJn4QSNTur+of0MNKy/aeZYWLOv
	Fl+KaTPCHWvt4rWUnm4dyjJzI5YXaikZCMgNR0imjAxKnnobgFq3lPg9r54ZlHF/pJDHSS
	tk9nX+7GjwXoFFvgDEXlTzxfvP1/0+8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776500240; a=rsa-sha256;
	cv=pass;
	b=mTA7pUfPBqCPBeIPK94FW4HgAd4FQqJJ1IlMC3Cr/v1jOvNCjWiiczzQPW3ROPVdRORGNi
	1RkcNEvBnwhyt7KfyEwFeTRYDo2Fc6Gq8yzr2nm1Z6UWCHKBYJUPrNT8S4X51gFllgBN3q
	yNNgPkPGDOIsSh/o4pMJ4R3dD38yTPw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jvox7hix;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so2234621a12.0
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 01:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776500239; cv=none;
        d=google.com; s=arc-20240605;
        b=QXnfPxR42ANRxq7g01TXmiriY80OMqafJDkzjzFNI7CSvFqNxnSoND5yDBlqCf8kMM
         gO32VK5IQU8ThKBuHOjU4iGIYOsXDwWDjAT+RduCgZaUb0YZNwe9G46v4nzvn8k2q9q0
         a2vDd7FP7uyRLIM1bI9IBadByWT6DfXOC18rjD+DTcHEM3SsZNLvt6HCiQC5MUJwlvbD
         5maWjnf29zE4R4Bdna+EYlEGiNDtcb8CO0KSMCcV9l5qXWL+UER5ncGbXIUF4BO79tEE
         tFwgn82MAPERTftLO06AbJRPd7HEyuDknD4FsUEAKfwdBEyhn4WM277cTF9iHAqjLcwX
         iCrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=osHl21ka+EHE85SfgVEe4S+Jtjdn7o2ijvj352s1WKY=;
        fh=zLaRNTu0skg/vKAjwdfRDn5EtfNUP9HnJZvqIYf4pME=;
        b=CMURhoMudXiYXuwWHwzcN2tkDBcYpyZWkVHEByJMUBYU5FbVufs16e2fEt7COYMQ1i
         iicqFyMPi2qJD8Ys3RVqrnGxE5S2ltOkkTl1NHjBrzlfmaL4oi7Awv2180H1hsVVutSg
         kZ4ibQS5DPJdaUmGQwk/p5uB/RX6kw1LRnrxmxdHN64Pj7DAgXgYoUEKa1x7W3qqXb7B
         ih7veUjXDBOeWOGLXohZUe/B7SOkhvp5eW3vQhmqPlwCmedCru7w7Frm0NDJaDfDpPwX
         VYuXW+XT3Fffo7qI3iu37PaJAhhZSqxuXnrZDtlhItKAL/YHqM0MOCg+4yHBj873UIAk
         PJ4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776500239; x=1777105039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osHl21ka+EHE85SfgVEe4S+Jtjdn7o2ijvj352s1WKY=;
        b=Jvox7hixFbkwcRzaJQxS2vWAJjpszmicWSH4gRTcOh+6m/yIK+7+2+J+KPvy9j3Wcz
         nyuyOOIb1oWdpFbgAt4XczI7dIpoIJOgEnKWtTTdV0jfXIkCLNHR1RMguQf5092E6f58
         4QnbLJ9irqrqxgNxbqGaIUMg+Yxesr21uiDDUwxngPc0T5DBVefEsm4bgmOUYzrF4QaH
         Q+AW8jdQ1xZ1sg91G+LoyCw+tedVFRGN7HntZyaFiOUzyKilJ2uosum63RqCiAtkPPcD
         RlCT9mk556nB65b6xPVcYegA2T0v3etN2qWsziGl2Pd4V5PoNzMk19Y0BmMWniV6mLMd
         WqWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776500239; x=1777105039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=osHl21ka+EHE85SfgVEe4S+Jtjdn7o2ijvj352s1WKY=;
        b=CZTSbAWU4x6OKBQcaIHJmf+xbO8Vb1xHYnwA9AZUirtXPCI5QZt58TUjMvA+giDcIi
         fPszsfi0ZsRluOuOOA6v2uED+tNh8XE7Fg2HBtDvOaMHgq6UXxsu9LxiLuu7K7Xm/hsn
         /EMxn0ieaTm7SHCy80elcekC/2Hs6Wjdf683sgBczoHU86hH/1ORI/M4mHAgZkDTxpDb
         Oo40Q7ZGjKvEncZYT42jMLMpCy0VtmQBtFQAEPPdLheOxDN1ABQrgaTEVu/gp1o4FgSV
         tgcMn1mFMRCURuGWTFT9ncH7QzIDZG0sITMNE2lAubeGdrhENFqANs3O84wTDAtyUIvC
         xGxg==
X-Forwarded-Encrypted: i=1; AFNElJ9Gp8vhVDiCVaiixQDKKbMruWUxdpRgKgo1eRxsDRZVms5NjXVl6TBUA38sfgDNruV2DTEsWOTYgQ==@kvack.org
X-Gm-Message-State: AOJu0Ywore7rYqW+A3MkSPwFaTOobIgZoc17jpv6dRIWlSnItq4UuURE
	DdJmJII/n1Jtg0JLW3v8bne2woq3asaE2uaCnVnoCSySrZHnqID+V5gZUQ9C+2PlQ9owMVQoXM2
	9Xee3NmmLCc3yFnbCDf2h6ZB2mAIBrBM=
X-Gm-Gg: AeBDieuVB2OEzDa/TkcOzCHfbGkTIASTvRx1MEGP9y1WzFQyYCN+K1V8Sj+zy4AHNkR
	dD72h7HvZQil+7sfLhW2Hl+57WgMfR7HbJm+cFibfzJ38rNMgTQ7SFF+GosoEl50IxqYMLs9HGu
	5WOXx7Uy73MBrU5qWThbDQCcmR/WUo/kh3mh8RR1XeSIGhEZqg23dGGSFfUi3g0vP6dnKhTH5/8
	T9R57zAR0pBFKinp+dzjawuf0Ue5XcHsygBFk2qcaLzH5kuRk2J4sAUgq3q61U+lkF4w1WoLPH4
	0gU69AUnhZP55b2axMPEVPVrc5kpsy8FJkR3c4sg8JYcLCO0JE9Zh1waPkd1yw==
X-Received: by 2002:a05:6402:2790:b0:671:4f9a:9e4e with SMTP id
 4fb4d7f45d1cf-672bfed76b7mr2741127a12.24.1776500238643; Sat, 18 Apr 2026
 01:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260417025123.2971253-1-wxy2009nrrr@163.com> <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
In-Reply-To: <3a28d9d327d84ae192fb3dcb925a0674@honor.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 18 Apr 2026 16:16:42 +0800
X-Gm-Features: AQROBzApXlHnX_aFyc1uiRAuKaQO7RJs54KvufAWR5xki9NwlzhY7jkss4rXnOA
Message-ID: <CAMgjq7BsSMxia=nYA1n7d+sOq8RhRb-F6F7E6tt+R6buf7WZOQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] mm/mglru: improve reclaim loop and dirty folio handling
To: wangzicheng <wangzicheng@honor.com>
Cc: wangxinyu19 <wxy2009nrrr@163.com>, 
	"devnull+kasong.tencent.com@kernel.org" <devnull+kasong.tencent.com@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "baohua@kernel.org" <baohua@kernel.org>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"chenridong@huaweicloud.com" <chenridong@huaweicloud.com>, "chrisl@kernel.org" <chrisl@kernel.org>, 
	"david@kernel.org" <david@kernel.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"kaleshsingh@google.com" <kaleshsingh@google.com>, "laoar.shao@gmail.com" <laoar.shao@gmail.com>, 
	"lenohou@gmail.com" <lenohou@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"stevensd@google.com" <stevensd@google.com>, "surenb@google.com" <surenb@google.com>, 
	"vernon2gm@gmail.com" <vernon2gm@gmail.com>, "weixugc@google.com" <weixugc@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com" <yuzhao@google.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, wangzhen <wangzhen5@honor.com>, 
	wangtao <tao.wangtao@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fkembaukdg6jayjipa45ey5i4ukppqfm
X-Rspam-User: 
X-Rspamd-Queue-Id: 91260100007
X-Rspamd-Server: rspam05
X-HE-Tag: 1776500240-686592
X-HE-Meta: U2FsdGVkX18l5yy5MRPRWf9aY3MNVd6R2FxqYekxzaLz6QLPqo1w48Q1WTayI+igra0sv8fn8m9rOwOUtOd3ke+UmpXHRGJMoGbg2+1xt/vGg/tbxh12azSch3F/rGXoPMWkKteNvA85HpHeHyvSz4MK0of5ZP2DAXOZb/dpmMYjGpSFj5lVb9fAH+ZoypqbgDluoHMMs/mabqaaHwmaWPR38MSrqXlYOfpf3W1ZRuzmrvMBMuZdHom/+RBSBqSaFlOInfMhiikn2aAW0iG+sSZtYtheeBSt6rReWDFU5GjlwmzX0afxI39zJPmqtLGkCA6PjTc86+LPcqKyDCicZGlxLXmTLp5jcwja3pu0zaGOU9HQ9oleqV7mltQ0llAXDHr2Xc69QmwKRwnWq9YOhwfrcRN5yHhvYsSrT3wdUQRVBUNtNOb2yrHGurlp2P3PZWcGMFXTHnBlKWVrGBxGbKNRM9YUVd5a2QciHulCzTh0v2HUV8Ae9xyNVi9Mbt43oYbeL5lUToz7354IhQnBH79dzR9MkO1Lo3PrMRtN5PfhlflKl4YDD82FNkOVKPDdJng7Kbby5Kwtiw0VDEm7W6wwfACBtt9dJVOSicMJuPtbLrRq5jrzznCIwIB0dUbYamhtNxizjTGs+WQq7kPd/XmlWepXIFPV6GNGwdOe6CgZx0/vou/Uf40q2hbpKf0gujQwU8LpiIt3a71799ChfUrAq2Rw/rJBN9PortEOFhpaD1k18T9iICYqq58gY37C55/Dy6glZJ8jZpV9K5tAt1/mV4bsUav1OuP/7YlVdkK1fvOqXSSh2GQmt1XPwCI58DGRHbuF6R2kFYSJFvqQIv7cEwihqaXhTGxwnhO+jptg6EyEyzses3wgp1pG/6s/wVQsDvj2v+pKXJGCqSNBRlD1pgtcmNOsxvEUkn1qqnmIntNnEITRabRhT6gV39GbmF9DLj0npapyWfW1/FM
 yVlrMUSS
 6Ur5aRsiRE/zaXoiD+emvncLRnga0mmoqgIomkuCvjwoXC5fAiIrrK4CdcTYUGoNyvjlNm99iC7GD4Ane4qWlr9YEKK4laonZpnMZKHEeswyP3XRZzUq/Z7Az+7hHJLvKJsZ0vuPiIZccDrEdl/7CgRGRBdcmSYh+cObK/Ouh1dESE+eqJ4BNraRQkpOkS1eaB23foef8b3KN+4VzDxO2QVBg/aUtmaInVxdXTd8k3ydRQw0ZY2jeiMnmwdrDsRKGXhgp4tu47cEMx7PzfIN0wNjpFTZpFaLbuRiJd1RR7NFDAE97cMMu5TZy+VKvSjSKREkR0r4gtQSQ9f9DqloWDYpH50SWjdcuN7rcCgWJPeCqJLajHfARsHUMIMqYmSPiWTRYaW60Y8CNNvUA7pmHFKEMLUgEWMMInEebYrtXUpZwv09wg2BJIqXHHbValreTlYiCgDO9kVdefV07C9WSVcfcsJGyyddHOzCwGjqApk59c64vVVQxBoVssGR44orUxSnUiQeGUqFBfxKpyzDkXb3dGAKymufspqadf8GLXTFZFRkJIacY0yWi4Wf839Vp5Y0xHbSWgpOqaBYyKzA3g80q8Krh684RZCgOgxOZOV7mgCuB9V0EN9gIPu3wUUXh7oiW+iKgEF8Foys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 3:38=E2=80=AFPM wangzicheng <wangzicheng@honor.com>=
 wrote:
>
> > Hi Kairui,
> >
> > We have tested this patch series on Android device under a typical scen=
ario.
> >
> > The test consisted of cold-starting multiple applications sequentially
> > under moderate system load (some services running on the background,
> > such as map navigating, AI voice-assistant). Each test round cold-start=
s
> > a fixed set of apps one by one and records the cold start latency.
> > A total of 100 rounds were conducted to ensure statistical significance=
.
> >
>
> Hi Xinyu and Kairui,
>
> We have test the patch under a **heavy** load benchmark for camera.
>
> > Before:
> >   /proc/vmstat info:
> >     pgpgin 269,224
> >     pgpgout 226,078
> >     workingset_refault_anon 237
> >     workingset_refault_file 27689
> >
> >   Launch Time Summary (all apps, all runs)
> >     Mean 868.0ms
> >     P50 888.0ms
> >     P90 1274.2ms
> >     P95 1399.0ms
> >
> > After:
> >   /proc/vmstat info:
> >     pgpgin 223,801                (-16.9%)
> >     pgpgout 308,873
> >     workingset_refault_anon 498
> >     workingset_refault_file 17075 (-38.3%)
> >
> >   Launch Time Summary (all apps, all runs)
> >     Mean 850.5ms (-2.07%)
> >     P50 861.5ms  (-3.04%)
> >     P90 1179.0ms (-8.05%)
> >     P95 1228.0ms (-12.2%)
> >
> > --
> > Best regards,
> > Xinyu
> >
>
> We evaluated the backported patches on android16-6.12 using a **heavy**

Hi Zicheng

I'm not sure how you did that, this series applies on mm-unstable and
there is a large gap between that and 6.12.

> mobile workload on a Qualcomm 8850 device (16GB RAM + 16GB zram).
> (vmscan code in this tree is largely similar to v6.18)
>
> The workload simulates real user behavior by sequentially
> cold-starting 23 apps. For each application we perform the related
> operations (short=E2=80=91video swiping, background music playback, and
> navigation). After exiting one application the next is launched
> immediately in 1s. After all apps complete, the camera is launched
> and a photo is taken.
>
> Baseline and patched kernels were tested under identical conditions.
> (with a fan kept cooling the testbed)
> Full system traces were collected for three runs in each
> configuration, and ten additional traces were recorded for the final
> camera launch stage.
>
> Overall application keepalive behavior shows no noticeable
> difference. However, we observed performance deviations in some
> memory=E2=80=91pressure scenarios.
>
> Before:
> Meminfo (100 ms per sample, average result)
> MemAvailable: 5420
> MemFree: 1421
> Cached: 3862
> AnonPages: 3804
> Dirty: 62
> vmstat counters (last sample)
> pgpgin: 3,701,869
> pgpgout: 3,545,058
> workingset_refault_anon: 390,967
> workingset_refault_file: 79,927
> Total app launch time (23 apps + launcher =C3=97 23): 7702 ms
> Camera launch time: 684 ms
>
> After:
> Meminfo (100 ms per sample, average result)
> MemAvailable: 5058 (-7%)
> MemFree: 1382 (-3%)
> Cached: 3213 (-17%)
> AnonPages: 3637 (-4%)
> Dirty: 35 (-44%)
> vmstat counters (last sample)
> pgpgin: 5,752,429 (+55%)
> pgpgout: 3,668,788 (+3%)
> workingset_refault_anon: 1,492,964 (+282%)
> workingset_refault_file: 590,505 (+639%)
> Total app launch time (23 apps + launcher =C3=97 23): 8872 ms (+15%)
> Among the tested apps, 11 improved while 14 regressed.
> Camera launch time: 980 ms (+43%), which is also the stage with the
> highest memory pressure.
>
> From whole trace analysis, direct reclaim appears to run slower.
> Before v.s. after
> total duration: 11659 ms / 57006 ms

Being 5 times slower seems really horrible, but I'm not sure what is
causing that as there seems to be very few dirty folios in your test
case. I knew there are some vendor hook for android, and since now
MGLRU is using the common routine, so these hooks are also affecting
MGLRU but the modules ain't aware of that which is causing strange
behavior?

> total reclaimed: 3953 MB / 6344 MB
> speed: 0.339 MB/ms / 0.111 MB/ms
> times: 16117 / 27562
>
> The performance might behave differently on devices with smaller memory
> (e.g. 8=E2=80=9316GB) compared to servers with 100+GB memory, or under
> moderate to heavy memory pressure.
> Could this be related to patch 09/14[1] which removes folio_inc_gen()
> when ` writeback || (type =3D=3D LRU_GEN_FILE && dirty)`?
>
> Any comments or suggestions would be appreciated.

Can you share the code you actually tested or maybe test in on
mm-unstable / mm-unstable + this series? Or how can we reproduce that?
Or maybe some full log or dump of lru_gen info and vmstat?

>
> [1] https://lore.kernel.org/linux-mm/20260413-mglru-reclaim-v5-0-8eaeacbd=
dc44@tencent.com/T/#m568eba84d35d8d5ff519d3e29237de6d64f67659
>
> Best,
> Zicheng
>

