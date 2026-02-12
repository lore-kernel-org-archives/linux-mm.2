Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E6CEEA84B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDED56B0089; Thu, 12 Feb 2026 13:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C7C6B008A; Thu, 12 Feb 2026 13:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C186B008C; Thu, 12 Feb 2026 13:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92DB06B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:37:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B34F135DD0
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:37:25 +0000 (UTC)
X-FDA: 84436662450.20.4AB8886
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2EB1CA0011
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:37:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YAZcy08I;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770921443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLnTkMoihnLKB9Wj8wWo21U9EDR8kDp4XW1jqwP0b5c=;
	b=fV99ZUbV6yN6Hua77KaOtTZUVluxLRq92svacRlR6PoUH9477LQQ160gwVu292B6UQ1Ddd
	pR1AhNwgnDWvOUN4zkndCxH0zJNsxZWg8szkEgCc9gF8MExW/RMVDm/aCxi9m6tP7wuSfD
	FMuhq2MTNLfhO6PEHi7Rbx9XQ7XN3ug=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YAZcy08I;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770921443; a=rsa-sha256;
	cv=pass;
	b=scck167x40skleTDwyIdAQx+SbOkrXFcdHhpCq2BsCdSRr4sl0V7iKJkZeEZh9iTqOH2+O
	LPRdkmcRt4ELZnsfgvuRlGYDW9etENJYyZ8n75CQY8nEKGKppvn8/wztquxs+OZtQu4CQu
	1Pi4i0f7SoQYoSsLHSBr2n9g1pAoKxM=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso1251235e9.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:37:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770921441; cv=none;
        d=google.com; s=arc-20240605;
        b=PV8WRvqj54+1RWqAjDQJ0VigWfTh2T+nW8so/O8/8EovwCu2y9+pDiGLQnPIrYqlQB
         43cioom3RKsmVTYJYgAwGSZZ+AsguHy5pVR77oFnp+DzVmJHFeRePBhn4CXpY8HTc3LX
         Gz5jzUi8SUM7FD2hE0u6V2tm8PhoSGa0uOWTRDVeWs2kyPkxIIJTRt3CibPAuuc1vSH+
         WyzFFBBzvo0ioJXPmN/k9WdXv+MVFdIun01mwCxTLztOvsrk8aOt+WD8RNwnDJ44CwJk
         blDlCuYTZPTUmzkXJrXlin68Et//59ivQPJjwJpE7FQX7Cnugw8Cv9kf8UtXijenLC8d
         9KMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WLnTkMoihnLKB9Wj8wWo21U9EDR8kDp4XW1jqwP0b5c=;
        fh=bv+p+bzhWvOvyOtKtb9h85okr1iG4nA6WFlRSkbfK0k=;
        b=KdPf/DtNmodKwdZaIW+kBCcmyBrGU+U5Q4YYq5+dCcpCVsx6soJneotDIttGISY4n+
         bjDqNAtkZeeZ8JRUyzRp3oqjMx6/QIYEg1wLibvFePNnvX+OAG4xjEwyntkS88DmiJrN
         utgaLC+SxYI57yIkx4vNUki+Lrpj456LPYPjtYHng4FD9d1C54u7AcbeF+C0CMYL/1vv
         vD6q8yTAHAlabRNnSf+b/jy/cCtkb3kEjCMiP1ROgL6uLU/DGIYvZ8mFiLizvkxn4FPz
         RpSE+kDwBA26sUfiFO4JH8bIESsFoFqgeZsI1bZ7XpuUDyY1ETm4epX/U+/5vT/VRQuW
         yxKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770921441; x=1771526241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLnTkMoihnLKB9Wj8wWo21U9EDR8kDp4XW1jqwP0b5c=;
        b=YAZcy08I2DStN+ZpF92lHAAUNGc0AaWzBh/0FagjXSGpd9zayaFQwivMCklE7m6Nfa
         iOVXfOY8EDS/8tQ5/IDiZb7auIhbOOcNZdJu6kwQ+bu4vP9bFVOejE/2mwEG3p6jOALp
         RXY044QGQbwOQOglfW2nBwBpBFGgE2AhH04tx/MFpyQNUNcyueIOPzaw1Ll0odhzJ9Uo
         Y6TkUivBXO8vmwLz7EqwVslbeLilA1yaJVX9YIGN8Y9xXYB/Q23wik4z/s2fyKo4xqo1
         FN/yx1hr5o2zfPND2U2enhg5OsxzAQWT3pemTbbCDRtLzOnCV7FxThgmrbtAUheeW2c1
         5rCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770921441; x=1771526241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WLnTkMoihnLKB9Wj8wWo21U9EDR8kDp4XW1jqwP0b5c=;
        b=vwYCKrAgv3r35fL2/K/ekWv4Fz68azctlB4ukMjjf3ptbowY7E+yJ4HJXwN1v62G2m
         2iLSElEQo11NcLbdqcp3BSa5z6jiE/AxCd0IUTAX7iVbjlJHuEXMAXF4D9/iJH9fzOP5
         qvEY3TTSsSxg5XKFxz3/MTjX04pXjgj73xXR6e8w/FrKp2LpwC5SAx45K8KomMPrYKhg
         yVReKqi+d6e/FJZb3vpseIa8jFVOkDcW0YnZ4Wxwk9PnyXkjr8W+9Njjlyn6DiSV3oyo
         hE9w06bBR0Eu58850NQGJrj9nopkM8AG68Yfc8YuNq5BTP9hRyPpo9zX/HiCpsT+VPzL
         Q9sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnIe1SscUIwwaxtSm1tPXAfy42XRDjmeBXMxTFvsuPuiiOFWlMPdY8WJ2TrhXvKgx1BDkSwoa51A==@kvack.org
X-Gm-Message-State: AOJu0YyGz7Z9hVJ77SsWC4rFZsAQZ2qAI6Ddk0yxYEr/0RtZWSBiB9SM
	7Hufv4b8uQ/l5lLzxwncDO3DFOTil9FlmFzsS6no5flc6uxWo/n7CKPfUmpYtvcyeoX/nsxLeP5
	d6+LWDeI7VYDNWTlsVtLUqHrhszKjD+0TIw==
X-Gm-Gg: AZuq6aIvx/fmlcMNns3FN/phEaEpEG1qx8TedxyO5YM6hGZHTU/RQ9B8eItqYAnMCmu
	H8NCiJ/WDXlGduKU8e5qUyrlUPCdo7ufkE7jptOwOeJL3AMDccL/KJBmp7ErfHHjgeH8JnFIdIR
	6yohKh9zbxiWZlCDe8IogzCOZ5GVlljXfHx1LsfN03A5/8LcxXorcMENlWOgzO3FovB5R/6PD6d
	ByZp2a3XQwNYawDWt0dryC4aa4R8AcHUu+CYgPYHaKShmVjHaqZTYxD5pvFkL6SToZqHg0TNmNS
	Hko5rDMZy61DCHSzPWtRYb9lpD7FdvxtJ8FTp8M/Vb2Rs59UfOXgn5D/cAB4F6RjPj5GcCHFfCc
	bq2Qtn10h
X-Received: by 2002:a05:600c:4584:b0:471:700:f281 with SMTP id
 5b1f17b1804b1-4837103f325mr1212805e9.25.1770921441384; Thu, 12 Feb 2026
 10:37:21 -0800 (PST)
MIME-Version: 1.0
References: <aY3+Raf8eZqipCd6@e129823.arm.com> <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
 <aY4Vipl+4rGa+u6D@e129823.arm.com>
In-Reply-To: <aY4Vipl+4rGa+u6D@e129823.arm.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 12 Feb 2026 10:37:10 -0800
X-Gm-Features: AZwV_Qh2H9arrkEzFgzvlw2KMGFV_EufEVAdwcgyUIVoqVCpCV_6wxWLmvz8MGY
Message-ID: <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-mm <linux-mm@kvack.org>, 
	bpf <bpf@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org, 
	ryan.roberts@arm.com, kevin.brodsky@arm.com, sebastian.osterlund@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2EB1CA0011
X-Stat-Signature: sybsuxdmq7edqm6qf99pytbsw169du6o
X-Rspam-User: 
X-HE-Tag: 1770921442-864309
X-HE-Meta: U2FsdGVkX18ujcNZfP4cpTx4HODu88WuphSiKFJ6vN5BJJ2OUZPOzPQDop2l+Lx/q5ZAbVkAuOg/2eKib3ma+NlG+P9+UIhL3zqIrMG8OZ04sfDnD9GIGo2kMVbBDUNF0gvAnRfDAlH4pf3q7D0FuDFfjpYKCZFzvJ6+5zSQW/QvFBsKEDTOWroRRupTepPQTSO5cZfrgO2LALn4GGKU7R3KTqtcKA6ioSDU0cElRyz2/z/+uZ2gnKO2wpbqOXNCZOPbAEu61TT6Gs/eG1TNdhQg6V5cuJ0PGZl7I4JmlP2jBOCLYyGqhcQHBjpnnXCyPTwlCbIstPpcr9VcmskOkzvLOuyxJmMvpgizgcZn5nD1ZbBRb9xLj+CJvePUdqn6CvfLH8hxw4+FPsIitZMaIaEoAPhMm+MHA/gQeBbIVLjKh6+moW8hPPiKPHp1/xkwRIhLULyxJiFnpHXcM2XxZlP1nV1QkB9v4aRjpmcXYwwTaH72gL6X57uqyojDsjcy3vqqepfQcw0i97MlS5E9gmMEWmn19ucLISEwW3OnCN+vQodilg6C30R1lU1qnEs1cy8VK4XAOV/jTG4GCt7I1H4FPbue/4FUSENjlD12/LlyVlL/46G0H3lFKHJcpL/Xk7m5vEAg2xFiKGjc6YVjKULgZd3M4YjkXhsK6vaRYj9nUDcX1lT6PajpWPdcLEVrgeKWWhdif3kPWfJW8xFjgK2oL1Eye8EjowSi5T5/HeWvbx31Ycuh5LbQAy4I1EpG3HVMQcavbpw2070/4x0hnWLNAAGmCpTQ0hMovYbykilaDzK59IDdPV0z/y4vhgl0ahbs/ZmeCRx2ZDgxGmjSeniJEEj6s8RV/YZAx50NMsfCa5HSIXbrfe3sYZZzS7fbsJmUkpxuIFudifZ/v196MUBL24ldMlBVleklx8+uid2K4cjaKvcpVRAKWbdTv/K+u4MYTP64Bi44tyVbNxQ
 u6g2PJQD
 oCe5z/Ut+ITH7c3PlX4mNVCi0WYtaratc31opesXJ+7LoEjIvz4eTP8YEk7FP3nDRO2qD/M+zaNI8xQhiutwiW2B0CI1VHy3US2jALGM6nBR6b8+vidTciVinx6L8u3qUMO7LPX5Vzqh8c0MCNp24Ste3CE3kWhuLsY3Xed1Trv1xcHrPulsfBXp6wU4K9Ki3/FA/cyTiS0v3js4uADDUx7VvlXYY6U9FftX8sVRI//Iee19nd1pFdQo47JZrj54AX09DsM4F+FTjqIcWXqmmOWYwgLt64HNN/XYc5GhiYT4E68iGzEoUMZ7HFmqfqzEyBAHLK5TZZz2QTHZno/WVrcotNUj1P7P3c9aSlH1+hjl8S5W8Z+36IGNoHtrAW1uBPRRhPgkgYNuZ1N70GZfCQHwbioHtXt78ZYpoEOCuIfECUQUQTNtIPlQqQkNsy0UEf14n2zcI+lCLqGAZObly1NfDG45gRv17Gb6zOBpVv7mwfi0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 10:03=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com> =
wrote:
>
> Hi Alexei,
>
> > On Thu, Feb 12, 2026 at 8:24=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.co=
m> wrote:
> > >
> > > Hi all,
> > >
> > > I would like to propose the topic of eBPF isolation with pkeys at the
> > > upcoming LSF/MM/BPF summit.
> > >
> > >
> > > Background
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > Today, eBPF programs provide powerful capabilities to extend kernel
> > > functionality without requiring modifications to the kernel itself.
> > > These capabilities are largely enabled by the eBPF verifier, which
> > > enforces memory safety and other constraints to protect the kernel.
> > >
> > > However, vulnerabilities in the verifier have repeatedly demonstrated=
 that
> > > eBPF programs can also become a serious attack surface.  In several c=
ases,
> > > flaws in verifier logic have allowed malicious eBPF programs to bypas=
s
> > > safety guarantees and compromise kernel security.
> >
> > eBPF was restricted to root for many years, so the above is simply not =
true.
> >
> > > Representative CVEs include:
> > >
> > >      - CVE-2020-8835   [1]
> > >      - CVE-2021-3490   [2]
> > >      - CVE-2022-23222  [3]
> > >      - CVE-2023-2163   [4]
> >
> > None of them are security issues. They're just bugs.
> > Like all those found by syzbot.
> >
> > > An RFC series is planned for around Q2 2026, and the experimental
> > > implementations for eBPF isolation with pkey and pkey-aware memory
> > > allocators have already been completed internally.  Using these
> > > implementations, we verified that eBPF programs running under isolati=
on
> > > successfully execute several sched_ext applications provided by
> > > tools/sched_ext, as well as some bpf kselftest cases.
> >
> > The stated goal is wrong, hence not interested in patches
> > or discussion at lsfmm.
> >
> > arm has a nice hw feature. Sure, but this is not a place to apply it.
>
> That is correct =E2=80=94 this is a verifier bug.
> However, the concern is that such a bug can lead to a security incident.
> Not only root, but also users with CAP_BPF who are allowed to
> load eBPF programs could potentially trigger additional security issues
> through such bugs.

Again. They are not security issues. cap_bpf is effectively root.
Just like cap_perfmon in tracing space is a root.

