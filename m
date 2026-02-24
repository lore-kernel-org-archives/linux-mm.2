Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0EBEFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E446B0088; Tue, 24 Feb 2026 02:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BE96B0089; Tue, 24 Feb 2026 02:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23FA6B008A; Tue, 24 Feb 2026 02:10:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB8B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:10:14 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31A2413ABC6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:10:14 +0000 (UTC)
X-FDA: 84478476348.30.BD6E8E4
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C938180008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:10:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxpHEpDm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771917012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDh1X58CGtHIEhOJ5O4lzeYx8yT2192S5lE07B7Mlx4=;
	b=NUovgqgr6gGz5tTi4Izrs4pDlGRVBKgY1LMHoKpy0c+/+fErZrK72XIK6q43cWhyD+buqP
	Bonn21hNwWQezdbh0PB2s8LoZjtzeKXYDGk4+YCvUqR+LEI6lxZp/T4AfCvwOnSi7vC2dZ
	vMlq2yKtfAVcxxEw5BUuJxxzvGxcrfQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771917012; a=rsa-sha256;
	cv=pass;
	b=MOjezpeFDijpf6Q/aTkUb//ZJpvZUnc4S1eQTuIxZc62MBuanW1BVZUiTw1YbxJRFo/c4a
	LM+IDFayTlDMwMwp6tF0Nlip22HSRLJbUVHV41Jn1yxxeOMK5b/BYqL04sRp6XNDhlu5DS
	SWUWTCZF5qGmu8LdkLZ09XEGwCnhUNw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lxpHEpDm;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb3dfb3461so530443385a.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:10:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771917011; cv=none;
        d=google.com; s=arc-20240605;
        b=VlRgec29AKf/dDgwcSR+Xh7vOQAT3ek9sKqtOD32/kRI3Vp+9aT8Lf6G1l7xITMZRz
         +SuFqi7bAUcK4ecUnrCPOALMGsC6hb4yVed9avvRHn+QlQQoZMZUSOgXgd/9lS/ESTg2
         jWRdxNysNkvHZ2JZ2lA7w96psV1OEYYSmnIQezSOJJW+/6JiRDaBZvqkRBjJywD+JQoh
         ws7mxmK7KRmrfsXpLYntjHxsM85fowEcuRnoEk5yeCHZxowgb2sZ+jKDkWtTZapHM+N9
         vC8z+lKyMg+WuMs7buOX3nObbGLU1yGVZ43I7qIE4fGuCZnbIBRoGYpWULA4ViNhXBqj
         iprQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rDh1X58CGtHIEhOJ5O4lzeYx8yT2192S5lE07B7Mlx4=;
        fh=v7hqCUwraDWOcfgu5J5658K1SDNv3w8hD4Cr+Ebfrlo=;
        b=K6fMNpkcrkp8q04mczrGPoh8YV7GN9DTPgf/A6sZZw91i1Ma3mzL+HLxnVxKbdwBwq
         MF2Bt7ObNz80MUEFmgnFAf7DftJo92ymusdjYcryizXz9L8mH4BQNliAi+ZI0xgv2Cq3
         9/V7pyrP9lyYpiT5OQWZkUn8QZTrt5515FUAiHnM3LXAJlmxbG68h54/fCHl2xwI5NTe
         4WtW3VOPDVoBEK779LSdBtprNmOgjBEIjWSegRlREDDvbw7wL43qyei08OXcY8lCY09b
         eLjKLEY8SD9V3JiC3ViUvS9fXb3AQGR5RmzzJG6ZPGDzgsSWxjxp1NwV38xO1glWGUTh
         EFKg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771917011; x=1772521811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDh1X58CGtHIEhOJ5O4lzeYx8yT2192S5lE07B7Mlx4=;
        b=lxpHEpDmAZKxCcP6dwt6XtiZ1Tfk2eOsJ+z8zit8L3HjICuu+RXTgh4Z9yFUcxOTSZ
         dymD4j/Z7h5F27OGiXddmnZuS3XPEBrGF/bf3GhrNezODC2Q4WzPvrlD7vLwJfj10Tmr
         0yGpUdheDp65d6f7CPhckLuaPUhppKdMviDUSVtzepJosXZES2erT1vgViNc5STxYFbX
         5XfLh1AkyVvs4Ex0Z3SU2mBlvD+2g4GWtZBJGW+QRcdR9O6yLx46qFOTeKkWr4F+rvjG
         zdlJbSxRfQlaaXbmWC03k5MyWWQkgHGdfRrZ/uZhUW7iSR7CiNUXzTQVacpg+mDoX/au
         ggtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917011; x=1772521811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rDh1X58CGtHIEhOJ5O4lzeYx8yT2192S5lE07B7Mlx4=;
        b=BoTqyhIIyWAT4YOIOyvAXOAc1TGFsEXOnR6nWAr94Zi/osx0W7P6nXcuisDCiEObyL
         EMaSyT69W1oHNe/4iIeVN62VEEz69wB0hCg+yZjJSzRgsMsCDcKiAVwcjYgnZoAZR7Px
         RykybEYIQ4q1c0DORO3Rc+FXt5JPfa2cM2+Ima15A8fIxGOMEmvcwrG4QwmyKKKMHF7A
         AjkF8xzGurH+J2Hvf4Ai0tpml6jzDaD/KmBuwlB8cja2x8H0P/+u5WDGTs0/JZGtGGXS
         ocfa78E1EOEHBkSqheJrFm/5zELFXbNvxR4agFG9v3ujn2b7Fs+nocIbXaV79EQQ3tmo
         ikgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxd1hFJ7oXsSqL+lNLQ7FqQBO7Y2oycEiv/zliGkZGGrmSwYZcz5vYoFTUUDydUVa84KwecL+5Kw==@kvack.org
X-Gm-Message-State: AOJu0YzbokKeJ32vn8hKTrIIHYo1CPIEDJnWoKCRaSZKvxvs2iIXJq2p
	lFXhg0SoYLsEsk66j916nYXjUtfRM097z1gRk4jF8PC5i/RtEIOuy6HqRxMJJtibeU8rkNjACgV
	qe0Wu4aDN/JJtTDI1tvvMwjcu4ghh0KNr5A==
X-Gm-Gg: AZuq6aJaP5bDAQxJnWVabuXRS0WNXEVPtXfTQ2d4QosRni1xPQpS0gecqvGgXHyx9IF
	5YoT6ESOKVX02AXM2UxNnb9MsXbdbb6/ePcZ1tpO8CDIm+G6u/ebQytp+QqhYdHHmlkiXSl2V2U
	5+qeEf7mRrSHUMQ3Y6u3tMrKFTkgeqrd+O8ypwc5RqY54wC19RpOhdyYVv0Pte2PIIUDXdcwIY0
	Ntg2wGNPU1bdHwygcxlsnsp1Eso8QOKxiMWNWj16ujbFaRsee4ocQQLTaoTQkws7lMbOJ2oOWRz
	/e8vYw==
X-Received: by 2002:a05:620a:4542:b0:8cb:49e8:d465 with SMTP id
 af79cd13be357-8cb8c9cdf1amr1435936685a.1.1771917010858; Mon, 23 Feb 2026
 23:10:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com> <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 24 Feb 2026 15:09:59 +0800
X-Gm-Features: AaiRm50gV_sbQYWqKJT2FRdoGoyzbrwY32xyRnOfje3kmZ02Y2IDouBJLsb2AOI
Message-ID: <CAGsJ_4y2wR3wgJbx-kTSzrEYaWXJv=oSVdy0SE2VzSzoyMX=Gw@mail.gmail.com>
Subject: Re: [PATCH 1/5] mm: use inline helper functions instead of ugly macros
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: mbc7t4khgkmq57b6knfny637ud5f8krp
X-Rspamd-Queue-Id: 3C938180008
X-Rspam-User: 
X-HE-Tag: 1771917012-180688
X-HE-Meta: U2FsdGVkX18oVN7YmAHoD1TteVUUbkSkW97ri+vE8Z4pZOBxJvtSjislfVGdAAcOaqZ1eGTQ0p2C0EfyX2/YjZenDgifml9cDjY4kSo6eVRQnNkTracwyj8xRWt5GAV3XDMprpZOnwkrZwACkk7tOJgrN6Zm6eJ6csOrleO43RWdRSSa0KJXF4cvyUTA7rB59dnDxzEB0p30nO3jd//gHfVxd1rFuykAP5YQp7oxYliglbfFRcr+ggJaRGNpPUuFyhhqyMMpwa0uIAQKeYDOglT4l+WYt5kvjdSPDpG26E5CX8mk4ZJ9HOBLaw3yJ7wfbhQynBOkzclSpo84zurxH9g+CkNriQTr9cMRT6Lk53GbGPVRqXWWGnRfGGFCZtCuzuqAx6MIG/Sv5rxQTjNCMaYqKzpzMYIIrcvuepCuBpH/Jvxtw5MgCAIdLc8xFHFyGloB3M8oln8FGLoZbQMjyiHgShG5gFtu2Vju48XxDhrVkqhaogN8I+lJMZ72CximbwomrDwQGGtW/SXy/gTyN1bzeMsvl/JDgxD+5JQ1RaR7fmPtLnvxRDE8cMrnyGrorC1V/J3j1Al+6/CJEAUiuukiq+/6oZLQjh6X/WHeL19WkvDIr1+SuNvY721WgEfHg6ajuTGLQAytQWwr7lZfVPwNjmeEP5u+6nvS0iwqthUEROZre/asBTfxnB4qhiY5UPLXAb8A03x6mhJyXWPsUbzA6HjV0PPFACUgkKMaIKpqSpHFc96jhNKLfYMlZho10nbxItIKVDCYwfvA2vzO3wMTf9uygBX7Qxm2Ol2Ww5VzGBrUuGZITq3bet4peRntmYNiMFRGtmqvADjvnlE9lMKQYxpFYBjKD5MhtcBo3JpyEL64JTqhd8qKiQLBDxUsY3dhvF8FOOqw4FgN8GIpZgjcn9n3FrA6Mpw5jtey3O3EzYdmbKmTKXvun+dVdtpk7pP7QJZgju/yHTNN+1e
 8i1x+XZL
 Oer+38PTKRVVGB52oPNk9HJoNp4Il00zuRi3qv2zP9OhVxURVyoyIyz/h6ovSa72z7JtFTLCJ4BoCh8v1W7GiEKg4x5YDFL/dpRE0KLblW9yEaEH8Id34ijqRUyvsWI8CQ/GhwEMj6833YbqhmzZ1/OzIU4xhjFSiViKyQWRvDJtEchJ46tSyb6O49tAOEJwedwJYVT3Czz3VcGmidj4ARsB7CIVChxG0wGX3EnnGXuG78snUniyS//syMuHg7902xJXXheeMim6T7x1d3o2HSzKAkPtytObySBguYqZkPTNSplmHSfpHVJVO3wDRw7+a+Ci6i3hNuyw8IK8+pq+VQpKwlboj2msz4LTrqZS1e3X4NLWCSftL2RlCoysfmXzhakFnDueijN+D8max4hYnIRymF2WnK2gBosi9gQ5cCgCc9nLOkgevfbvtqxhycpLj3pmC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:02=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> People have already complained that these *_clear_young_notify() related
> macros are very ugly, so let's use inline helpers to make them more reada=
ble.
>
> In addition, I cannot implement these inline helper functions in the
> mmu_notifier.h file, because some arch-specific files will include the
> mmu_notifier.h, which introduces header compilation dependencies and caus=
es
> build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover, since
> these functions are only used in the mm, implementing these inline helper=
s
> in the mm/internal.h header seems reasonable.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

