Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD53107BCE1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 19:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C34B6B0088; Fri, 13 Mar 2026 15:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A6A6B0089; Fri, 13 Mar 2026 15:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F106B008A; Fri, 13 Mar 2026 15:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F40A26B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:42:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95BB456CF2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:42:49 +0000 (UTC)
X-FDA: 84542062458.20.C070212
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id A427C180002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:42:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7tFjvt4;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773430967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6tap4Xvv6Aj398CJevRoAsoPEctM1t3K/HC/O/0HwY=;
	b=4ncx64q4ACPmGC8+Io+ADFBdBs8lQSivijNjEFv/u2vhAx3AvN9RZk82Z6F1xo8rEQuZSF
	dSwFlUS2xXmbyfCUCsvM0Hp0KBQsT2fV+lRGaAXSeOlpP9IKc4ARvUnXB1+O54i7424a6z
	/TreVm+2DerNDCO7vjHeN0bpEHMEuJU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q7tFjvt4;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773430967; a=rsa-sha256;
	cv=pass;
	b=gmtGS2xv7+iWe31Lf5JtKYaGF0BcwB56ieEqZa2yxt9YilKLSUWLPGkhZVKA2rSG75D2gi
	Ow2eBPZdrCRFQaBDap/7ABA83jusgcm/JOdHx+wIP/HWkikg7xfVTwLDQpvxXfRjQset6s
	dSUACTgeG5M3fXyzt5WGMZ4LSMwnmBw=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64ca9ec3ee7so3177608d50.3
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773430967; cv=none;
        d=google.com; s=arc-20240605;
        b=Hl6bL7DX+JUO+HzYCXcDzk7UOCj49Pske7HLZj5zXXGZah7DdVQ0/78VxX+kYxbynP
         GCYdylmncDXXKrjQXRDljgp+K1NFpvKFl6MS1iClsda57vK7YTIUWT+J+oiBP53YwQt4
         fSdZfbalzKBCg7drX4OD1MbNugJkFI17lqmTFBSz8CDZX2QevztVCpORlBWhEE35NsQw
         NE7VUIkCWIEso6/fUCpPo7b6KeSlEo+qF0QOlAmslr258p4wh3Mykvk91vOCLxeoejWu
         UXWPGUI0ycicLPu4TfCBGoztMRtXFXuKEipWw3j7k3f7gp2ujgv+4G8W0a7a5otyDa+0
         3Phg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L6tap4Xvv6Aj398CJevRoAsoPEctM1t3K/HC/O/0HwY=;
        fh=gU6NgCmhyMuS+VbdQprvZMXfizrxf/D+GdTFyTl3QDA=;
        b=Of4UOf/hUtVFQ6UQ4KYPAFUJx/Orf+bEhK/2ExEmUImjHLG4bzCX9e2cau0e+ix7l1
         QepYfn7XoA2MJWsC5Zp2DS4wS8KsD1gKpBYsWLNCFGD9E6DoiwopuKdvWZPlG0OE353H
         c5aiWAxXJYHpQsC1RkwvrA+Hnmk4PK/ZoFxEzrdFa9zVX1EFBobikVuYOepd6ItIecSS
         WOxwubdWzqSwDXKqdaiuB8U6IzDaAV/yuD/JEBMGzjkb2zVuLYmZ3OnOw1SXkXQh7EOi
         Nm4rcAaDnB2VMZZjkvRidy74yR2brW7dOgSCOY4J1HYoLSGbtPoXYEPEePkqJpiAvZ2A
         mSzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773430967; x=1774035767; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6tap4Xvv6Aj398CJevRoAsoPEctM1t3K/HC/O/0HwY=;
        b=Q7tFjvt4f6yc5Y8bwbg9kB2wR9MaHdPAuDYKTUTZqKec8gBY4cpwf02eZYBp4VDJ+7
         +becbC1s3XGtEgTv9Ad1Qc2nIVOhHDdkVWtWbGdjF8HiRrf5pF8RV8auuI8rl0CD28F+
         FfQdj+VayhQpZOTbWpWGHr3wP+feAt+/f8Tq00WTZAtrgTDUG9G6+e4pUuAnoDB5krn9
         +eDX+ABQfE5YGa139Sb9cF8ymDrQHh1JeVhwjzbD8p3cjwazpm9XdgHMV8slKEL45DEh
         UoqiNt6LmT7aCrjjBvFikWeTvYK/5eLrMSO4DixbcwgLRGkV+i15nwfICJPbHLWpR3s3
         sgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773430967; x=1774035767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L6tap4Xvv6Aj398CJevRoAsoPEctM1t3K/HC/O/0HwY=;
        b=dvCByA4k/E1smy1kD15WpqqIfyK+i8gwwhMDy0cbaYAxjP2JBuQRAfGhzc4rv0P6G8
         fICkdtPXNvsX2BbQUNf3MHshaiEQZ5Y/WYnCu7q9PjAH78YikOycPYfinVfwlpEMFbQi
         vluXzLSyXSMVlUoClru2NFZ6I3u/BXS+PO5TQMQAeEjQiwOKKomy4+OL7CEuDOdEKPIs
         crqmN1S7nljUOkcKYZDh17gpwBwqgj6t5OT6rA5Q+fSw3cYw1ECwbPyeLF3gT69xRLoX
         +EIzqEJGt0LDFmCfUidmlIvh5mKLXjZg1PMu9i3IQx55R1Eg9Hc/CWpEPIgzV1rdlrDn
         BjdA==
X-Forwarded-Encrypted: i=1; AJvYcCX5X0MP0PC3xAwNjSIvSo4Jxvz6nFzPfg5PV0K7+q6fkf0WPNmyJDGWwu5kjfSBcnBV4wIA8h11aw==@kvack.org
X-Gm-Message-State: AOJu0YxkuVZ0zrsRuXkLor1dZWkKi1lhXIC5U8CV9z0o3Rs2kZHz/flQ
	Oe+ubXrzgdBE1iskgHDJSiT5zwluiG1YDv8BgR6wONM35z6IEE2lUzixQIKML954o5yaYmHRnLe
	6T+0KDSssVYgq/eDP3qThTjPAmO0a1So=
X-Gm-Gg: ATEYQzySZd1NY9tbhy//+LSRBdQaVXP0fNiqHzpA048FJ5hqOv1btA8wQ53eMZzO4n6
	/D2OVDXX5zTmmMYJeqVJQInqqmHVoREMVRMDBREym3ZSkrn0rzvmdwLAwH7GSRtsa2TRyxVHOfF
	2KG33HOVHziYIlC2ZBesMBTPjMENx3+N/1wokMxW+8eexP2ZztvzpquVnWGX6dsa9yk0kEgLnb4
	zXGLwXRa+mHygzQZJ0seSAvHGmQLBE61dqSGiArTLq1DPw0Ayw6nEiI5Zs4LyJ4Xt27nKPLxtQF
	vEwJ/aTyjRonGzz0H2psfjgqmkGfsYXiAiGPtn1OZw==
X-Received: by 2002:a53:4c08:0:b0:64a:d74f:2583 with SMTP id
 956f58d0204a3-64e62f32b83mr3773314d50.8.1773430966683; Fri, 13 Mar 2026
 12:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260313111702.38667-1-aethernet65535@gmail.com> <20260313145247.46643-1-sj@kernel.org>
In-Reply-To: <20260313145247.46643-1-sj@kernel.org>
From: Liew Rui Yan <aethernet65535@gmail.com>
Date: Sat, 14 Mar 2026 03:42:35 +0800
X-Gm-Features: AaiRm50ChEh4InPvjYO_yVBmE9ldBcHvaYymROpXYmMM2sWnTfV5xLuyxfxPYQg
Message-ID: <CAPLv50pLx+Jk+7so9uWrpy8qzOnvSr5QkbJkQL-kctEwkx=qOQ@mail.gmail.com>
Subject: Re: [Question] mm/damon: conflict between DAMON_STAT and DAMON_LRU_SORT?
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A427C180002
X-Stat-Signature: 7xs648rkrrzzmdgzwh47dtckas1rpabh
X-Rspam-User: 
X-HE-Tag: 1773430967-215685
X-HE-Meta: U2FsdGVkX18pDWmZnfePbbFUiuOG+gW5Y3BWMia/W3q6nlwtLOJIJb0iweSLFy+711aCvk17ZV+YOZAFTpIh3ABXKBePFjfHFz8GwB0sEYf3kFkqEYk5amXNqNqVmCXRiQh4zZOjMv0UCW4uXSpDiW0nTQQByeuAcpqCkiNqvw7S4zLUsg0Zt54ZBVnmsbjmz8yIMCnJgB08BFheGfmEuDQsWvov+0X3yiIZRiawQcnLq7YYt2Ih9OYD5JyyK9esst+XTDxjX10H+zsUZRrBVNXZ3wkybctlndIgc0StLS/vVbA1AXmV0Ajvf1T0Tv1GKdrOP58KJe4LFxwqiwAQWm94CguMUPnHs5IVZiSfi8FYu/v34NyGTgbdSkHNUfeiEeZDjnoJlNk2ZJtoL3Mgxxib0OE8rMwt/6WCvNLvRNhN6D8vyKTyibS/KYS1rdYgbKftP4jCSkzDNXLaTh3VStOVEFYm5BXhOsv1DKKwfAOtk1ocLcerT7ppt8zqjc9I38JQnfZXr98v5JCfSP/xqGvqyrAeosbmeEMyloDOhkrmBbsGEXdYkAFh4ffHkwtJgE5Ef7zuMNc6nR4jRQXAXKr4ajIKhtIrEpwo7TMhkhWirVZuUJoOSejF5vJgR+GUPmEjvaSJud+TRoUlReVRqM5of7bDoPUgXzp+V4yiqql4Xo3EzHJg91CSCUd3bOL4NZZMX9tdRu4588y8s1Lh8mgSaBTzg9RZ3KW7GJkLiXjEFHyD9yA5RAhnqiPtx5KphOb+YMfaNBn3eqIZWcZ/QO2SfUZwnfUMEmU5VfeqSjitUN65OCnioPXAHTdw0c4FqQPrK9pKEdBUGVTzxsKOyLe+mG8IEteHpOxcDDxSl1mY1/zNpPiO3fuyYOMFnxpwW7HhPZ70zzTtrI7VJbjK1LNFj3zz8j4PDIt5aeFG4cefsowPWIJU+rTQHk9F4W3AwP6n5LW9dxzhorjBq13
 grug2IGj
 Sqm9pQbJbBp3fiJiuR71FXkdAAoGwUoTrDAAgOFSceRJHb9zhEZkGNvibmMW8qIIi491aS7Yf+yciNSw39TMzsK3ps5ISeFx7WugwI3UXIgjB1tS6gzfKkMnFAdXMWzD5CGYU8OGemtSXySeZ70BiQl8vKGQEZLzbtCKReczX7jEv74Pe1wvXFd7vUeSuwFPFlH+8HCevXXhAUOAkkwBR6yxTutwI/O9up7RjyZf6Gzmb6Rt6Lb2/NV+xQ92I7zpQK9gsRsFsL/AF2vhjhRO9vxiDvMG5r4Mt7S0oRwBGJLuxmfg7bUxd2FjY48Cf+AQHhHlYwLCoJ2TXzApYYm0RvjN30H1tA35pCPbakchTxYpsspXWLsMwuhBsT/LKOQea678c88cJZoVS9XBNpGfai3dZdmRgZsVgqOlgzIlvRyuk9+VyWK7HHhPMzYApVp5TbQIsgI5NRkX7te6p5PqnUIBTcQttib2ZwqEwXRsOZA3u7yCbZKcDK7gerJFhdewXvMR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 10:52=E2=80=AFPM SeongJae Park <sj@kernel.org> wrot=
e:
>
> Yes.  But, I think 'Special-Purpose Access-aware Kernel Modules' section =
of
> Documentation/mm/damon/design.rst is a better place to document it.
>
> Would you mind sending a patch for that?
>

Hi SeongJae,

Thank you so much for your quick and detailed reply!

I'm happy to send a documentation patch for this. As you suggested, I'll
add the explanation to the "Special-Purpose Access-aware Kernel Modules"
section of Documentation/mm/damon/design.rst.

Additionally, would it be helpful to add a short note with a :ref:
cross-reference in Documentation/admin-guide/mm/damon/lru_sort.rst
pointing to that section? I think this could help sysadmins quickly
understand the reason behind the -EBUSY error without having to dig deep
into the full design document.

I may need a few days to prepare the patch properly, I want to
familiarise myself with the reStructuredText syntax and the current
design.rst. I'll do my best to send it soon. Is that okay?

Thanks again for your guidance and for maintaining DAMON!

Best regards,
Liew Rui Yan

